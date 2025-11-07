import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/home/presentation/screens/coach_detailes_screen.dart';
import 'package:nasaa/features/home/presentation/widgets/coach_card.dart';

class FavoriteCoachesScreen extends StatefulWidget {
  const FavoriteCoachesScreen({super.key});

  @override
  State<FavoriteCoachesScreen> createState() => _FavoriteCoachesScreenState();
}

class _FavoriteCoachesScreenState extends State<FavoriteCoachesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // context.read<HomeCubit>().addOrRemoveFromFavorite();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Coaches")),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state is HomeSuccessState) {
            final coaches = state.favoriteCoches ?? [];

            if (coaches.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No favorite coaches yet'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: coaches.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CoachCard(
                    coach: coaches[index],
                    onTapCoachCard: () async {
                      final cubit = context.read<HomeCubit>();
                      final navigator = Navigator.of(context);
                      final coach = coaches[index];

                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        await cubit.getCoachesDetails(coach.id!);

                        // Close dialog
                        if (navigator.canPop()) {
                          navigator.pop();
                        }

                        final state = cubit.state;
                        if (state is HomeSuccessState &&
                            state.coachDetails != null) {
                          await navigator.push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: CoachDetailsScreen(
                                  coachDetails: state.coachDetails,
                                ),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (navigator.canPop()) {
                          navigator.pop();
                        }
                        log('Error: $e');
                      }
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("favorite Coaches")),
  //     body: BlocBuilder<HomeCubit, HomeState>(
  //       builder: (context, state) {
  //         if (state is HomeSuccessState) {
  //           List<FeaturedCoachModel>? coaches = state.favoriteCoches;

  //           return coaches!.isNotEmpty
  //               ? ListView.builder(
  //                   itemCount: coaches.length,
  //                   itemBuilder: (context, index) {
  //                     return CoachCard(
  //                       coach: coaches[index],
  //                       onTapCoachCard: () async {
  //                         final cubit = context.read<HomeCubit>();

  //                         // Store the navigator state BEFORE showing dialog
  //                         NavigatorState? navigatorState;

  //                         showDialog(
  //                           context: context,
  //                           barrierDismissible: false,
  //                           builder: (dialogContext) {
  //                             // Capture the navigator from dialog context
  //                             navigatorState = Navigator.of(dialogContext);
  //                             return const Center(
  //                               child: CircularProgressIndicator(),
  //                             );
  //                           },
  //                         );

  //                         try {
  //                           await cubit.getCoachesDetails(coaches[index].id!);

  //                           // Close dialog using the captured navigator state
  //                           navigatorState?.pop();

  //                           final state = cubit.state;
  //                           if (state is HomeSuccessState &&
  //                               state.coachDetails != null) {
  //                             await navigatorState?.push(
  //                               MaterialPageRoute(
  //                                 builder: (_) => BlocProvider.value(
  //                                   value: cubit,
  //                                   child: CoachDetailsScreen(
  //                                     coachDetails: state.coachDetails,
  //                                   ),
  //                                 ),
  //                               ),
  //                             );
  //                             // if (context.mounted) {
  //                             //   _fetchCoaches();
  //                             // }
  //                           }
  //                         } catch (e) {
  //                           navigatorState?.pop();
  //                           log('Error: $e');
  //                         }
  //                       },
  //                     );
  //                   },
  //                 )
  //               : Text("List Empty");
  //         }
  //         return Text("faild");
  //       },
  //     ),
  //   );
  // }
}
