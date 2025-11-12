import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_state.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_state.dart';

class CoachDetailsScreen extends StatelessWidget {
  const CoachDetailsScreen({Key? key}) : super(key: key); // ✅ بدون parameters

  @override
  Widget build(BuildContext context) {
    // ✅ نجيب الـ coachId من الـ Cubit نفسه
    final coachId = context.read<CoachDetailsCubit>().coachId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Details'),
        actions: [
          // زر المفضلة
          BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              // final isFav = state.isFavorite(coachId);
              // return IconButton(
              //   onPressed: () {
              //     context.read<FavoriteCubit>().toggleFavorite(coachId);
              //   },
              //   icon: const Icon(Icons.favorite_border),
              // );
              if (state is FavoriteLoaded) {
                final isFav = state.isFavorite(coachId);

                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    context.read<FavoriteCubit>().toggleFavorite(coachId);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),

      // ✅ نستخدم BlocBuilder لعرض البيانات
      body: BlocBuilder<CoachDetailsCubit, CoachDetailsState>(
        builder: (context, state) {
          if (state is CoachDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CoachDetailsLoaded) {
            final details = state.coachDetails;

            return RefreshIndicator(
              onRefresh: () => context.read<CoachDetailsCubit>().refresh(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة المدرب
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: details.userProfile?.url != null
                            ? NetworkImage(details.userProfile!.url!)
                            : AssetImage(
                                "assets/images/coach with image null.jpg",
                              ),
                        child: details.userProfile?.url == null
                            ? Text(
                                details.name?[0] ?? 'C',
                                style: const TextStyle(fontSize: 32),
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // الاسم
                    Text(
                      details.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // التقييم
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          details.avgRating ?? '0.0',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${details.numberOfReviews ?? 0} reviews)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // النبذة
                    if (details.about != null) ...[
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        details.about!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // الخبرة
                    if (details.yearsOfExperience != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.work_outline),
                          const SizedBox(width: 8),
                          Text(
                            '${details.yearsOfExperience} years of experience',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // الأنشطة
                    if (details.activities != null &&
                        details.activities!.isNotEmpty) ...[
                      const Text(
                        'Activities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: details.activities!
                            .map(
                              (activity) =>
                                  Chip(label: Text(activity.name ?? '')),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // اللغات
                    if (details.languages != null &&
                        details.languages!.isNotEmpty) ...[
                      const Text(
                        'Languages',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: details.languages!
                            .map((lang) => Chip(label: Text(lang.name ?? '')))
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // زر الحجز
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to booking
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CoachDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoachDetailsCubit>().getCoachDetails();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
