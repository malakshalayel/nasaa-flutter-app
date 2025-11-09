import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_state.dart';
import 'package:nasaa/features/coaches/presentation/widgets/coach_card.dart';

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
                // show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  // Simulate delay or perform lightweight prefetch if needed
                  await Future.delayed(const Duration(milliseconds: 300));

                  Navigator.of(context).pop(); // close the loading dialog

                  // Navigate and let the route create its own cubit
                  Navigator.of(
                    context,
                  ).pushNamed(RouterName.coachDetails, arguments: coach.id);
                } catch (e) {
                  Navigator.of(context).pop();
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
