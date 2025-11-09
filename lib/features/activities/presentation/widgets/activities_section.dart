import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/activities/data/models/activity_model.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_state.dart';
import 'package:nasaa/features/activities/presentation/widgets/activity_item.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_cubit.dart';
import 'package:nasaa/generated/l10n.dart';

class ActivitiesSection extends StatelessWidget {
  final List<ActivityModel> activities;
  final VoidCallback? onSeeAll;

  const ActivitiesSection({Key? key, required this.activities, this.onSeeAll})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// --- Header Row ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).activities,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: scheme.onBackground,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  S.of(context).seeAll,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        /// --- Horizontal Activities Scroll ---
        SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return ActivityItem(
                activity: activities[index],
                onTap: () {
                  context.read<CoachCubit>().getCoachesWithFilters({
                    'activity_ids[]': [activities[index].id],
                  });
                  Navigator.pushNamed(
                    context,
                    RouterName.coachesByActivityScreen,
                    arguments: {
                      'activityId': activities[index].id,
                      'activityName': activities[index].name,
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
