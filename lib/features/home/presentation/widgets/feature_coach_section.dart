import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/home/presentation/screens/coach_detailes_screen.dart';
import 'package:nasaa/features/home/presentation/widgets/coach_card.dart';
import 'package:nasaa/generated/l10n.dart';

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
              Text(
                S.of(context).featureCoach,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  S.of(context).seeAll,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
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
            );
          },
        ),
      ],
    );
  }
}
