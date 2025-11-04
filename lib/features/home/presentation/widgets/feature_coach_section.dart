import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/home/presentation/screens/coach_detailes_screen.dart';

class FeaturedCoachSection extends StatelessWidget {
  final List<FeaturedCoachModel> coaches;
  final VoidCallback? onSeeAll;

  const FeaturedCoachSection({Key? key, required this.coaches, this.onSeeAll})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// --- Header ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Feature Coach',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A2E0F),
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See All >',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8B5E34),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        /// --- Coaches List ---
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: coaches.length,
          separatorBuilder: (_, __) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final coach = coaches[index];
            return CoachCard(
              coach: coach,
              onTapCoachCard: () async {
                final cubit = context.read<HomeCubit>();

                // Store the navigator state BEFORE showing dialog
                NavigatorState? navigatorState;

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    // Capture the navigator from dialog context
                    navigatorState = Navigator.of(dialogContext);
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                try {
                  await cubit.getCoachesDetails(coach.id!);

                  // Close dialog using the captured navigator state
                  navigatorState?.pop();

                  // Navigate
                  final state = cubit.state;
                  if (state is HomeSuccessState && state.coachDetails != null) {
                    navigatorState?.push(
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
                  navigatorState?.pop();
                  print('Error: $e');
                }
              },
              // onTapCoachCard: () async {
              //   print('🔵 Step 1: Starting coach card tap');

              //   // Save ALL context-dependent references BEFORE any async operations
              //   final BuildContext stableContext = context;
              //   final cubit = context.read<HomeCubit>();
              //   final navigator = Navigator.of(stableContext);

              //   print('🔵 Step 2: Saved cubit and navigator references');

              //   // Show loading dialog
              //   showDialog(
              //     context: context,
              //     barrierDismissible: false,
              //     builder: (dialogContext) =>
              //         const Center(child: CircularProgressIndicator()),
              //   );

              //   print('🔵 Step 3: Showing loading dialog');

              //   // Fetch coach details using saved cubit reference
              //   try {
              //     await cubit.getCoachesDetails(coach.id!);
              //     print('🔵 Step 4: Coach details fetched successfully');
              //   } catch (e) {
              //     print('🔴 Error fetching coach details: $e');
              //   }

              //   print(
              //     '🔵 Step 5: Checking if context is mounted: ${context.mounted}',
              //   );

              //   // Close loading dialog and navigate using saved navigator reference
              //   if (context.mounted) {
              //     print('🔵 Step 6: Context is mounted, popping dialog');
              //     navigator.pop(); // Close dialog

              //     print('🔵 Step 7: Getting cubit state');
              //     final state = cubit.state;
              //     print('🔵 Step 8: State type: ${state.runtimeType}');

              //     if (state is HomeSuccessState && state.coachDetails != null) {
              //       print('🔵 Step 9: Navigating to coach details screen');
              //       navigator.push(
              //         MaterialPageRoute(
              //           builder: (_) => BlocProvider.value(
              //             value: cubit,
              //             child: CoachDetailsScreen(
              //               coachDetails: state.coachDetails,
              //             ),
              //           ),
              //         ),
              //       );
              //       print('🔵 Step 10: Navigation completed');
              //     } else {
              //       print(
              //         '🔴 State is not HomeSuccessState or coachDetails is null',
              //       );
              //       print('🔴 State: $state');
              //     }
              //   } else {
              //     print('🔴 Context is NOT mounted!');
              //   }
              // },
              // onTapCoachCard: () async {
              //   // Save ALL context-dependent references BEFORE any async operations
              //   final cubit = context.read<HomeCubit>();
              //   final navigator = Navigator.of(context);

              //   // Show loading dialog (optional)
              //   showDialog(
              //     context: context,
              //     barrierDismissible: false,
              //     builder: (dialogContext) =>
              //         const Center(child: CircularProgressIndicator()),
              //   );

              //   // Fetch coach details using saved cubit reference
              //   await cubit.getCoachesDetails(coach.id!);

              //   // Close loading dialog using navigator reference
              //   if (context.mounted) {
              //     navigator.pop();
              //     final state = cubit.state;
              //     if (state is HomeSuccessState && state.coachDetails != null) {
              //       navigator.push(
              //         MaterialPageRoute(
              //           builder: (_) => BlocProvider.value(
              //             value: cubit,
              //             child: CoachDetailsScreen(
              //               coachDetails: state.coachDetails,
              //             ),
              //           ),
              //         ),
              //       );
              //     }
              // }

              // Get the updated state from saved cubit reference

              // Navigate to details screen using saved navigator reference
              // },
            );
          },
        ),
      ],
    );
  }
}

// ============================================
// CoachCard Widget - Used in both FeaturedCoachSection and CoachesByActivityScreen
// ============================================

class CoachCard extends StatelessWidget {
  final FeaturedCoachModel coach;
  final VoidCallback? onTapCoachCard;

  const CoachCard({Key? key, required this.coach, required this.onTapCoachCard})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skills = coach.skills ?? [];
    final displaySkills = skills.take(3).toList();

    return InkWell(
      onTap: onTapCoachCard,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🟤 Profile image + border
          Stack(
            alignment: Alignment.center,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 26,
                backgroundImage: coach.profileImage?.url != null
                    ? NetworkImage(coach.profileImage!.url!)
                    : const AssetImage('assets/images/defult_coach.png')
                          as ImageProvider,
              ),
            ],
          ),

          const SizedBox(width: 12),

          /// 👤 Coach Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        coach.name?.isNotEmpty == true
                            ? coach.name!
                            : 'Alexander Montgomery',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          coach.rating?.toStringAsFixed(1) ?? "4.5",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A2E0F),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFA500),
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Skills chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final skill in displaySkills)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F1ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A2E0F),
                          ),
                        ),
                      ),
                    if (skills.length > 3)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F1ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+${skills.length - 3}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A2E0F),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Starting price
                const Text(
                  'Starting form: 100 QRA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
