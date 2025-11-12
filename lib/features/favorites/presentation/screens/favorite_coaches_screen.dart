// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nasaa/core/injection.dart';
// import 'package:nasaa/core/router/router_name.dart';
// import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_cubit.dart';
// import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_cubit.dart';
// import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_state.dart';
// import 'package:nasaa/features/coaches/presentation/widgets/coach_card.dart';
// import 'package:nasaa/features/favorites/data/model/favorite_model.dart';
// import 'package:nasaa/features/favorites/presentation/cubit/favorite_cubit.dart';
// import 'package:nasaa/features/favorites/presentation/cubit/favorite_state.dart';
// import 'package:nasaa/features/favorites/presentation/widgets/favorite_coach_card.dart';

// class FavoriteCoachesScreen extends StatefulWidget {
//   const FavoriteCoachesScreen({super.key});

//   @override
//   State<FavoriteCoachesScreen> createState() => _FavoriteCoachesScreenState();
// }

// class _FavoriteCoachesScreenState extends State<FavoriteCoachesScreen>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() {
//     // ✅ Load both favorites and coaches data
//     context.read<FavoriteCubit>().loadFavorites();

//     // ✅ Check if coaches are already loaded, if not, load them
//     final coachState = context.read<CoachCubit>().state;
//     if (coachState is! LoadedCoachState) {
//       context.read<CoachCubit>().getCoaches();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Favorite Coaches')),
//       body: BlocBuilder<FavoriteCubit, FavoriteState>(
//         builder: (context, favoriteState) {
//           // ✅ Loading state
//           if (favoriteState is FavoriteLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // ✅ Error state
//           if (favoriteState is FavoriteError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Error: ${favoriteState.message}'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<FavoriteCubit>().loadFavorites();
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // ✅ Loaded state
//           if (favoriteState is FavoriteLoaded) {
//             final favoriteIds = favoriteState.favoriteIds;

//             // Empty state
//             if (favoriteIds.isEmpty) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.favorite_border, size: 80, color: Colors.grey),
//                     SizedBox(height: 16),
//                     Text(
//                       'No favorite coaches yet',
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             // ✅ نجيب بيانات المدربين الكاملة من CoachCubit
//             return BlocBuilder<CoachCubit, CoachState>(
//               builder: (context, coachState) {
//                 if (coachState is LoadedCoachState) {
//                   // ✅ فلترة المدربين المفضلين فقط
//                   final favoriteCoaches = coachState.coaches
//                       .where((coach) => favoriteIds.contains(coach.id))
//                       .toList();

//                   if (favoriteCoaches.isEmpty) {
//                     return const Center(
//                       child: Text('Loading favorite coaches...'),
//                     );
//                   }

//                   return RefreshIndicator(
//                     onRefresh: () async {
//                       await context.read<FavoriteCubit>().loadFavorites();
//                       await context.read<CoachCubit>().refresh();
//                     },
//                     child: ListView.builder(
//                       itemCount: favoriteCoaches.length,
//                       padding: const EdgeInsets.all(16),
//                       itemBuilder: (context, index) {
//                         final coach = favoriteCoaches[index];

//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           // child: FavoriteCoachCard(
//                           //   coach: FavoriteCoach(
//                           //     id: '1',
//                           //     FavoriteId: '12',
//                           //     name: 'John Smith',
//                           //     profileImage: 'https://example.com/john.jpg',
//                           //     rating: 4.5,
//                           //     skills: 'Fitness, Nutrition, Strength Training',
//                           //     level: 'Expert',
//                           //     status: 'Online',
//                           //     isFavorited: 'true',
//                           //   ),
//                           //   onTap: () {
//                           //     print('Tapped on coach');
//                           //   },
//                           //   onFavoriteToggle: () {
//                           //     print('Toggled favorite');
//                           //   },
//                           // ),
//                           child: CoachCard(
//                             coach: coach,
//                             onTapCoachCard: () {
//                               // ✅ Navigation بسيط ومباشر
//                               Navigator.pushNamed(
//                                 context,
//                                 RouterName.coachDetails, // ✅ استخدم الـ route
//                                 arguments: coach.id,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }

//                 // Loading coaches
//                 if (coachState is LoadingCoachState) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 // Error loading coaches
//                 if (coachState is ErrorCoachState) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Error loading coaches: ${coachState.message}'),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             context.read<CoachCubit>().getCoaches();
//                           },
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return const Center(child: Text('No coaches available'));
//               },
//             );
//           }

//           return const Center(child: Text('No data available'));
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_state.dart';
import 'package:nasaa/features/coaches/presentation/widgets/coach_card.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_state.dart';

class FavoriteCoachesScreen extends StatefulWidget {
  const FavoriteCoachesScreen({super.key});

  @override
  State<FavoriteCoachesScreen> createState() => _FavoriteCoachesScreenState();
}

class _FavoriteCoachesScreenState extends State<FavoriteCoachesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // ✅ تحميل المفضلات من السيرفر (وبيحفظ في cache تلقائياً)
    context.read<FavoriteCubit>().loadFavorites();

    // ✅ تحميل بيانات المدربين إذا مش محملة
    final coachState = context.read<CoachCubit>().state;
    if (coachState is! LoadedCoachState) {
      context.read<CoachCubit>().getFeaturedCoaches();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ مهم لـ AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Coaches'),
        // actions: [
        //   // ✅ زر Refresh
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: () {
        //       context.read<FavoriteCubit>().loadFavorites();
        //       context.read<CoachCubit>().refresh();
        //     },
        //   ),
        // ],
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, favoriteState) {
          // ✅ Loading state
          if (favoriteState is FavoriteLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading favorites...'),
                ],
              ),
            );
          }

          // ✅ Error state
          if (favoriteState is FavoriteError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${favoriteState.message}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FavoriteCubit>().loadFavorites();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ✅ Loaded state
          if (favoriteState is FavoriteLoaded) {
            final favoriteIds = favoriteState.favoriteIds;

            // Empty state
            if (favoriteIds.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorite coaches yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start adding coaches to your favorites!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            // ✅ عرض المدربين المفضلين
            return BlocBuilder<CoachCubit, CoachState>(
              builder: (context, coachState) {
                // Loading coaches
                if (coachState is LoadingCoachState) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading coaches...'),
                      ],
                    ),
                  );
                }

                // Error loading coaches
                if (coachState is ErrorCoachState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${coachState.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<CoachCubit>().getFeaturedCoaches();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // ✅ Coaches loaded successfully
                if (coachState is LoadedCoachState) {
                  // فلترة المدربين المفضلين فقط
                  final favoriteCoaches = coachState.coaches
                      .where((coach) => favoriteIds.contains(coach.id))
                      .toList();

                  if (favoriteCoaches.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Loading favorite coaches...',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([
                        context.read<FavoriteCubit>().loadFavorites(),
                        context.read<CoachCubit>().refresh(),
                      ]);
                    },
                    child: ListView.builder(
                      itemCount: favoriteCoaches.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final favoriteCoach = favoriteCoaches[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CoachCard(
                            coach: favoriteCoach,
                            showFavoriteIcon: true,
                            onFavoriteToggle: () {
                              context.read<FavoriteCubit>().toggleFavorite(
                                favoriteCoach.id!,
                              );
                            },
                            onTapCoachCard: () {
                              Navigator.pushNamed(
                                context,
                                RouterName.coachDetails,
                                arguments: favoriteCoach.id,
                              );
                            },
                          ),

                          // CoachCard(
                          //   coach: coach,
                          //   onTapCoachCard: () {
                          //     Navigator.pushNamed(
                          //       context,
                          //       RouterName.coachDetails,
                          //       arguments: coach.id,
                          //     );
                          //   },
                          // ),
                        );
                      },
                    ),
                  );
                }

                // Default state
                return const Center(child: Text('No coaches available'));
              },
            );
          }

          // Initial state
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
