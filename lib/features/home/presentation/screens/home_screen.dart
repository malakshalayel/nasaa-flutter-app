// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nasaa/config/cache_helper.dart';
// import 'package:nasaa/core/router/router_name.dart';
// import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
// import 'package:nasaa/features/home/presentation/widgets/activities_section.dart';
// import 'package:nasaa/features/home/presentation/widgets/feature_coach_section.dart';
// import 'package:nasaa/features/home/presentation/widgets/hedear_section.dart';
// import 'package:nasaa/features/login/data/repositories/user_repository.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? name;
//   List<String> imgaesBanner = [
//     "assets/images/header_home_imge.png",
//     "assets/images/header_home_imge.png",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _debugToken();
//     fetchName();
//     // Trigger the API call
//     context.read<HomeCubit>().fetchHomeData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.only(left: 10.0, top: 20),
//           child: Column(
//             children: [
//               HomeHeaderSection(
//                 userName: "nrrrame",
//                 bannerImages: imgaesBanner,
//               ),
//               SizedBox(height: 30),
//               BlocBuilder<HomeCubit, HomeState>(
//                 builder: (context, state) {
//                   if (state is HomeLoadingState) {
//                     return SingleChildScrollView(
//                       child: Column(children: [_buildActivitiesSkeleton()]),
//                     );
//                   }

//                   if (state is HomeSuccessState) {
//                     return Column(
//                       children: [
//                         ActivitiesSection(
//                           activities: state.activities!,
//                           onSeeAll: () {
//                             Navigator.pushNamed(
//                               context,
//                               RouterName.activityScreen,
//                             );
//                           },
//                         ),
//                         SizedBox(height: 30),
//                         FeaturedCoachSection(coaches: state.coaches!),
//                       ],
//                     );
//                   }

//                   if (state is HomeErrorState) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.error, size: 48, color: Colors.red),
//                           const SizedBox(height: 16),
//                           Text('Error: ${state.error}'),
//                         ],
//                       ),
//                     );
//                   }

//                   return const Center(child: Text("No data available"));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> fetchName() async {
//     final fetchedName = await CacheHelper.readSecureStorage(key: nameKey);
//     setState(() {
//       name = fetchedName;
//     });
//   }

//   Future<void> _debugToken() async {
//     final token = await CacheHelper.readSecureStorage(key: 'token');

//     log(
//       '🔍 Token in storage: ${token?.substring(0, 20)}...',
//     ); // Print first 20 chars

//     if (token == null || token.isEmpty) {
//       log('❌ No token found! User needs to login');
//     }
//   }

//   Widget _buildActivitiesSkeleton() {
//     return Skeletonizer(
//       child: Row(
//         children: List.generate(
//           4,
//           (index) => Column(
//             children: [
//               Container(decoration: BoxDecoration(shape: BoxShape.circle)),
//               Text(""),
//             ],
//           ),
//         ),
//       ),
//     );
//     ;
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/features/home/data/models/activity_model.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/home/presentation/widgets/activities_section.dart';
import 'package:nasaa/features/home/presentation/widgets/feature_coach_section.dart';
import 'package:nasaa/features/home/presentation/widgets/hedear_section.dart';
import 'package:nasaa/features/login/data/repositories/user_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20),
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
                            const Icon(
                              Icons.error,
                              size: 48,
                              color: Colors.red,
                            ),
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
        rating: "4.5",
        // Add other required fields with dummy data
      ),
    );
  }

  Future<void> fetchName() async {
    final fetchedName = await CacheHelper.getString(key: nameKey);
    log('Fetched name: $fetchedName');
    setState(() {
      name = fetchedName;
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
