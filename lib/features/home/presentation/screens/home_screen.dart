import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/config/locale_services.dart';
import 'package:nasaa/config/theme/app_theme.dart';
import 'package:nasaa/config/theme/theme_services.dart';
import 'package:nasaa/features/home/data/models/activity_model.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:nasaa/features/home/presentation/widgets/seetings_tile.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/home/presentation/widgets/activities_section.dart';
import 'package:nasaa/features/home/presentation/widgets/feature_coach_section.dart';
import 'package:nasaa/features/home/presentation/widgets/hedear_section.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? profileImage;
  String? email;
  List<String> imgaesBanner = [
    "assets/images/header_home_imge.png",
    "assets/images/header_home_imge.png",
  ];

  @override
  void initState() {
    super.initState();
    _debugToken();
    fetchName();
    context.read<HomeCubit>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeServices>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          children: [
            // ✅ Header stays OUTSIDE - no skeleton effect
            HomeHeaderSection(
              userName: name ?? "Guest",
              bannerImages: imgaesBanner,
            ),
            const SizedBox(height: 30),

            // ✅ Only this part gets skeleton effect
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final isLoading = state is HomeLoadingState;

                  final activities =
                      (state is HomeSuccessState && state.activities != null)
                      ? state.activities!
                      : _getDummyActivities();

                  final coaches =
                      (state is HomeSuccessState && state.coaches != null)
                      ? state.coaches!
                      : _getDummyCoaches();

                  if (state is HomeErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${state.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeCubit>().fetchHomeData();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Skeletonizer(
                    enabled: isLoading,
                    effect: ShimmerEffect(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      duration: const Duration(milliseconds: 1000),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ActivitiesSection(
                            activities: activities,
                            onSeeAll: () {
                              if (!isLoading) {
                                Navigator.pushNamed(
                                  context,
                                  RouterName.activityScreen,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          FeaturedCoachSection(coaches: coaches),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      drawer: Drawer(
        width: 350,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 8),
          children: <Widget>[
            SizedBox(height: 40),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: profileImage != null
                    ? FileImage(File(profileImage!))
                    : const AssetImage('assets/images/logo_app.png'),
                child: profileImage == null
                    ? const Icon(Icons.person, size: 30, color: Colors.grey)
                    : null, // Hide icon when image is loaded
              ),
              title: Text(
                name ?? 'Guest User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                email ?? 'No email available',

                style: TextStyle(color: Colors.blue),
              ),
              trailing: Icon(Icons.edit),
            ),
            SizedBox(height: 30),
            Divider(),
            SettingsTile(
              icon: theme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              title: theme.isDarkMode ? "Light mode" : "Dark mode",
              onTap: () async {
                await theme.toggleTheme();
              },
            ),
            Divider(),

            SettingsTile(
              icon: Icons.language,
              title: "Language",
              trailing: DropdownButton(
                items: [
                  DropdownMenuItem(child: Text("Arabic"), value: "ar"),
                  DropdownMenuItem(child: Text("English"), value: "en"),
                ],
                onChanged: (value) async {
                  await context.read<LocaleServices>().choiceLanguge(
                    value ?? "en",
                  );
                },
              ),
            ),
            Divider(),
            SettingsTile(
              icon: Icons.favorite,
              title: "favorite Coaches",
              onTap: () {
                Navigator.pushNamed(context, RouterName.favoriteCoachesScreen);
              },
            ),
            Divider(),
            SettingsTile(icon: Icons.notifications, title: "Notifications"),
            Divider(),
            SettingsTile(icon: Icons.info, title: "About Us"),
            Divider(),
            SettingsTile(
              icon: Icons.logout,
              title: "Logout",
              onTap: () => context.read<AuthCubit>().logout(context),
            ),
            Divider(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ✅ Create dummy data for skeleton loading
  List<ActivityModel> _getDummyActivities() {
    return List.generate(
      3,
      (index) => ActivityModel(
        id: index,
        name: 'Activity Name Loading Here',
        createdAt: 'Loading description text for activity',
        // Add other required fields with dummy data
      ),
    );
  }

  List<FeaturedCoachModel> _getDummyCoaches() {
    return List.generate(
      3,
      (index) => FeaturedCoachModel(
        id: index,
        name: 'Coach Name Loading',
        status: 'Specialty Loading Text',
        rating: 4.5,
        // Add other required fields with dummy data
      ),
    );
  }

  Future<void> fetchName() async {
    final fetchedName = CacheHelper.getString(key: CacheKeys.nameKey);
    final fetchImage = CacheHelper.getString(key: CacheKeys.imageKey);
    final fetchedEmail = CacheHelper.getString(key: CacheKeys.emailKey);

    log('Fetched name: $fetchedName');
    setState(() {
      name = fetchedName;
      profileImage = fetchImage;
      email = fetchedEmail;
    });
  }

  Future<void> _debugToken() async {
    final token = await CacheHelper.readSecureStorage(key: 'token');
    log('🔍 Token in storage: ${token?.substring(0, 20)}...');
    if (token == null || token.isEmpty) {
      log('❌ No token found! User needs to login');
    }
  }
}
