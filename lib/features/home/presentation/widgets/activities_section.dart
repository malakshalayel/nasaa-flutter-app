import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasaa/features/home/data/models/activity_model.dart';
import 'package:nasaa/features/home/presentation/widgets/activity_item.dart';

class ActivitiesSection extends StatelessWidget {
  final List<ActivityModel> activities;
  final VoidCallback? onSeeAll;

  const ActivitiesSection({Key? key, required this.activities, this.onSeeAll})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// --- Header Row ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A2E0F), // brownish title
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See All >',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8B5E34), // accent brown
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
              return ActivityItem(activity: activities[index]);
            },
          ),
        ),
      ],
    );
  }
}
