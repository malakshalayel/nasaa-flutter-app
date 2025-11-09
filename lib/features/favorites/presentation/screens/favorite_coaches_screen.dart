import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_state.dart';
import 'package:nasaa/features/coaches/presentation/widgets/coach_card.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_state.dart';

class FavoriteCoachesScreen extends StatelessWidget {
  const FavoriteCoachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Coaches')),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, favoriteState) {
          // ✅ Loading state
          // if (favoriteState is FavoriteLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          // ✅ Error state
          if (favoriteState is FavoriteError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${favoriteState.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoriteCubit>().loadFavorites();
                    },
                    child: const Text('Retry'),
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
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No favorite coaches yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // ✅ نجيب بيانات المدربين الكاملة من CoachCubit
            return BlocBuilder<CoachCubit, CoachState>(
              builder: (context, coachState) {
                if (coachState is LoadedCoachState) {
                  // ✅ فلترة المدربين المفضلين فقط
                  final favoriteCoaches = coachState.coaches
                      .where((coach) => favoriteIds.contains(coach.id))
                      .toList();

                  if (favoriteCoaches.isEmpty) {
                    return const Center(
                      child: Text('Loading favorite coaches...'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<FavoriteCubit>().loadFavorites();
                      await context.read<CoachCubit>().refresh();
                    },
                    child: ListView.builder(
                      itemCount: favoriteCoaches.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final coach = favoriteCoaches[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CoachCard(
                            coach: coach,
                            onTapCoachCard: () {
                              // ✅ Navigation بسيط ومباشر
                              Navigator.pushNamed(
                                context,
                                RouterName.coachDetails, // ✅ استخدم الـ route
                                arguments: coach.id,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }

                // Loading coaches
                if (coachState is LoadingCoachState) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error loading coaches
                if (coachState is ErrorCoachState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error loading coaches: ${coachState.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CoachCubit>().getCoaches();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: Text('No coaches available'));
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
