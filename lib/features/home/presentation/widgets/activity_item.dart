import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nasaa/features/home/data/models/activity_model.dart';

class ActivityItem extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onTap;

  const ActivityItem({Key? key, required this.activity, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFEDE9E3),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 🟤 Decorative border frame (from Figma)
                SvgPicture.asset(
                  'assets/svg_images/Clip path group.svg',
                  width: 60,
                  height: 60,
                ),

                /// 🏋️ Icon from API (SVG string)
                if (activity.icon != null && activity.icon!.isNotEmpty)
                  SvgPicture.string(
                    activity.icon!,
                    width: 25,
                    height: 25,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF4A2E0F),
                      BlendMode.srcIn,
                    ),
                  )
                else
                  const Icon(
                    Icons.fitness_center,
                    size: 28,
                    color: Color(0xFF4A2E0F),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 85,
            child: Text(
              activity.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
