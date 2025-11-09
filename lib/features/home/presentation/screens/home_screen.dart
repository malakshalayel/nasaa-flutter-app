import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/config/locale_services.dart';
import 'package:nasaa/config/theme/theme_services.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/activities/data/models/activity_model.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_state.dart';
import 'package:nasaa/features/activities/presentation/widgets/activities_section.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_state.dart';
import 'package:nasaa/features/coaches/presentation/widgets/feature_coach_section.dart';
import 'package:nasaa/features/home/presentation/widgets/hedear_section.dart';
import 'package:nasaa/features/home/presentation/widgets/seetings_tile.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
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
    "assets/images/header_home_imge.png",
  ];

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Called when the widget is inserted into the tree.
  ///
  /// This function calls [_debugToken] and [_fetchUserData] to get the user's data.
  ///
  /// It also calls the [getCoaches] and [getActivities] functions of the [CoachCubit] and [ActivityCubit] respectively.
  ///
  /// These functions are used to fetch the data of the coaches and activities from the server.
  /*******  7cc930cf-d4ba-4392-a122-cc799635c848  *******/
  void initState() {
    super.initState();
    _debugToken();
    _fetchUserData();

    // ✅ تحميل البيانات
    context.read<CoachCubit>().getCoaches();
    context.read<ActivityCubit>().getActivities();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeServices>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // ✅ Header - بدون skeleton
          HomeHeaderSection(
            userName: name ?? "Guest",
            bannerImages: bannerImages,
          ),

          const SizedBox(height: 30),

          // ✅ المحتوى مع skeleton
          Expanded(child: _buildContent()),
        ],
      ),
      drawer: _buildDrawer(theme),
    );
  }

  // ============================================
  // ✅ 1. بناء المحتوى الرئيسي
  // ============================================
  Widget _buildContent() {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, activityState) {
        return BlocBuilder<CoachCubit, CoachState>(
          builder: (context, coachState) {
            // ✅ تحديد حالة Loading
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
                () => context.read<CoachCubit>().getCoaches(),
              );
            }

            // ✅ عرض المحتوى مع Skeleton
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
                      // ✅ قسم الأنشطة
                      ActivitiesSection(
                        activities: activities,
                        onSeeAll: isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  RouterName.activityScreen,
                                );
                              },
                      ),

                      const SizedBox(height: 30),

                      // ✅ قسم المدربين
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

  // ============================================
  // ✅ 2. جلب الأنشطة (حقيقية أو dummy)
  // ============================================
  List<ActivityModel> _getActivities(ActivityState state) {
    if (state is LoadedActivityState) {
      return state.activities;
    }
    // Dummy data للـ skeleton
    return _getDummyActivities();
  }

  // ============================================
  // ✅ 3. جلب المدربين (حقيقية أو dummy)
  // ============================================
  List<FeaturedCoachModel> _getCoaches(CoachState state) {
    if (state is LoadedCoachState) {
      return state.coaches;
    }
    // Dummy data للـ skeleton
    return _getDummyCoaches();
  }

  // ============================================
  // ✅ 4. Dummy Data للأنشطة
  // ============================================
  List<ActivityModel> _getDummyActivities() {
    return List.generate(
      5,
      (index) => ActivityModel(
        id: index,
        name: 'Activity Name Loading',
        icon: '<svg></svg>', // Dummy SVG
        createdAt: DateTime.now().toString(),
      ),
    );
  }

  // ============================================
  // ✅ 5. Dummy Data للمدربين
  // ============================================
  List<FeaturedCoachModel> _getDummyCoaches() {
    return List.generate(
      3,
      (index) => FeaturedCoachModel(
        id: index,
        name: 'Coach Name Loading',
        rating: 4.5,
        level: 3,
        status: 'Loading',
        skills: ['Skill 1', 'Skill 2'],
      ),
    );
  }

  // ============================================
  // ✅ 6. Error Widget
  // ============================================
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

  // ============================================
  // ✅ 7. Refresh Data
  // ============================================
  Future<void> _refreshData() async {
    await Future.wait([
      context.read<CoachCubit>().refresh(),
      context.read<ActivityCubit>().getActivities(),
    ]);
  }

  // ============================================
  // ✅ 8. Drawer
  // ============================================
  Widget _buildDrawer(ThemeServices theme) {
    return Drawer(
      width: 350,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
        children: [
          const SizedBox(height: 40),

          // ✅ User Profile
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              backgroundImage: profileImage != null
                  ? FileImage(File(profileImage!))
                  : null,
              child: profileImage == null
                  ? const Icon(Icons.person, size: 30, color: Colors.grey)
                  : null,
            ),
            title: Text(
              name ?? 'Guest User',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              email ?? 'No email available',
              style: const TextStyle(color: Colors.blue),
            ),
            trailing: const Icon(Icons.edit),
          ),

          const SizedBox(height: 30),
          const Divider(),

          // ✅ Theme Toggle
          SettingsTile(
            icon: theme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            title: theme.isDarkMode ? "Light mode" : "Dark mode",
            onTap: () async {
              await theme.toggleTheme();
            },
          ),
          const Divider(),

          // ✅ Language
          SettingsTile(
            icon: Icons.language,
            title: "Language",
            trailing: DropdownButton<String>(
              items: const [
                DropdownMenuItem(value: "ar", child: Text("Arabic")),
                DropdownMenuItem(value: "en", child: Text("English")),
              ],
              onChanged: (value) async {
                if (value != null) {
                  await context.read<LocaleServices>().choiceLanguge(value);
                }
              },
            ),
          ),
          const Divider(),

          // ✅ Favorites
          SettingsTile(
            icon: Icons.favorite,
            title: "Favorite Coaches",
            onTap: () {
              Navigator.pushNamed(context, RouterName.favoriteCoachesScreen);
            },
          ),
          const Divider(),

          // ✅ Notifications
          SettingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {
              // TODO: Navigate to notifications
            },
          ),
          const Divider(),

          // ✅ About Us
          SettingsTile(
            icon: Icons.info,
            title: "About Us",
            onTap: () {
              // TODO: Navigate to about
            },
          ),
          const Divider(),

          // ✅ Logout
          SettingsTile(
            icon: Icons.logout,
            title: "Logout",
            onTap: () => context.read<AuthCubit>().logout(context),
          ),
          const Divider(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ============================================
  // ✅ 9. Fetch User Data
  // ============================================
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

  // ============================================
  // ✅ 10. Debug Token
  // ============================================
  Future<void> _debugToken() async {
    final token = await CacheHelper.readSecureStorage(key: 'token');

    if (token == null || token.isEmpty) {
      log('❌ No token found! User needs to login');
    } else {
      log('🔍 Token exists: ${token.substring(0, 20)}...');
    }
  }
}
