import 'package:flutter/material.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';

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
            return CoachCard(coach: coach);
          },
        ),
      ],
    );
  }
}

class CoachCard extends StatelessWidget {
  final FeaturedCoachModel coach;

  const CoachCard({Key? key, required this.coach}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skills = coach.skills ?? [];
    final displaySkills = skills.take(3).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🟤 Profile image + border
        Stack(
          alignment: Alignment.center,
          children: [
            // Optional border frame asset (if you want the brown ornament)
            // Image.asset(
            //   'assets/images/coach_border.png',
            //   width: 66,
            //   height: 66,
            //   color: const Color(0xFFB68B59),
            // ),

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
                        coach.rating != null ? coach.rating! : "0.0",
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

              // Starting price (you can update this field later when added to API)
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
    );
  }
}
