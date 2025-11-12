import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/config/theme/theme_services.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/activities/data/models/activity_model.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_state.dart';
import 'package:nasaa/features/activities/presentation/widgets/activities_section.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_state.dart';
import 'package:nasaa/features/coaches/presentation/widgets/feature_coach_section.dart';
import 'package:nasaa/features/home/presentation/widgets/hedear_section.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? profileImage;
  String? email;

  final List<String> bannerImages = [
    "assets/images/header_home_imge.png",
    "assets/images/header_home2.png",
  ];

  @override
  void initState() {
    super.initState();
    _debugToken();
    _fetchUserData();

    context.read<CoachCubit>().getFeaturedCoaches();
    context.read<ActivityCubit>().getActivities();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeServices>(context);

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(),
        body: Column(
          children: [
            HomeHeaderSection(bannerImages: bannerImages),

            const SizedBox(height: 30),
            // with skeltonizer lib
            Expanded(child: _buildContent()),
          ],
        ),
        // drawer: _buildDrawer(theme),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, activityState) {
        return BlocBuilder<CoachCubit, CoachState>(
          builder: (context, coachState) {
            final isLoadingActivities = activityState is LoadingActivityState;
            final isLoadingCoaches = coachState is LoadingCoachState;
            final isLoading = isLoadingActivities || isLoadingCoaches;

            // ✅ جلب البيانات أو Dummy Data
            final activities = _getActivities(activityState);
            final coaches = _getCoaches(coachState);

            // ✅ معالجة الأخطاء
            if (activityState is ErrorActivityState) {
              return _buildErrorWidget(
                'Error loading activities: ${activityState.message}',
                () => context.read<ActivityCubit>().getActivities(),
              );
            }

            if (coachState is ErrorCoachState) {
              return _buildErrorWidget(
                'Error loading coaches: ${coachState.message}',
                () => context.read<CoachCubit>().getFeaturedCoaches(),
              );
            }

            //  عرض المحتوى مع Skeleton
            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                duration: const Duration(milliseconds: 1000),
              ),
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ActivitiesSection(
                        activities: activities,
                        // onSeeAll: isLoading
                        //     ? null
                        //     : () {
                        //         Navigator.pushNamed(
                        //           context,
                        //           RouterName.activityScreen,
                        //         );
                        //       },
                      ),

                      const SizedBox(height: 10),

                      FeaturedCoachSection(coaches: coaches),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<ActivityModel> _getActivities(ActivityState state) {
    if (state is LoadedActivityState) {
      return state.activities;
    }
    // Dummy data للـ skeleton
    return _getDummyActivities();
  }

  List<FeaturedCoachModel> _getCoaches(CoachState state) {
    if (state is LoadedCoachState) {
      return state.coaches;
    }
    // Dummy data للـ skeleton
    return _getDummyCoaches();
  }

  List<ActivityModel> _getDummyActivities() {
    return List.generate(
      5,
      (index) => ActivityModel(
        id: index,
        name: 'Loading',
        icon: '<svg></svg>', // Dummy SVG
        createdAt: DateTime.now().toString(),
      ),
    );
  }

  List<FeaturedCoachModel> _getDummyCoaches() {
    return List.generate(
      3,
      (index) => FeaturedCoachModel(
        id: index,
        name: 'Loading',
        rating: 4.5,
        level: 3,
        status: 'Loading',
        skills: ['Skill 1', 'Skill 2'],
      ),
    );
  }

  Widget _buildErrorWidget(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.wait([
      context.read<CoachCubit>().refresh(),
      context.read<ActivityCubit>().getActivities(),
    ]);
  }

  Future<void> _fetchUserData() async {
    final fetchedName = CacheHelper.getString(key: CacheKeys.nameKey);
    final fetchedImage = CacheHelper.getString(key: CacheKeys.imageKey);
    final fetchedEmail = CacheHelper.getString(key: CacheKeys.emailKey);

    log('📱 Fetched name: $fetchedName');

    if (mounted) {
      setState(() {
        name = fetchedName;
        profileImage = fetchedImage;
        email = fetchedEmail;
      });
    }
  }

  Future<void> _debugToken() async {
    final token = await CacheHelper.readSecureStorage(key: 'token');

    if (token == null || token.isEmpty) {
      log('No token found! User needs to login');
    } else {
      log('Token exists: ${token.substring(0, 20)}...');
    }
  }
}
