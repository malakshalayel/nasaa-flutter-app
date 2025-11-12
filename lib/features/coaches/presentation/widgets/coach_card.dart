// import 'package:flutter/material.dart';
// import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';

// class CoachCard extends StatelessWidget {
//   final FeaturedCoachModel coach;
//   final VoidCallback? onTapCoachCard;

//   const CoachCard({Key? key, required this.coach, required this.onTapCoachCard})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final skills = coach.skills ?? [];
//     final displaySkills = skills.take(3).toList();
//     final theme = Theme.of(context).colorScheme;

//     return InkWell(
//       onTap: onTapCoachCard,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// 🟤 Profile image + border
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               // Profile Image
//               CircleAvatar(
//                 radius: 26,
//                 backgroundImage: coach.profileImage?.url != null
//                     ? NetworkImage(coach.profileImage!.url!)
//                     : const AssetImage(
//                             'assets/images/coach with image null.jpg',
//                           )
//                           as ImageProvider,
//               ),
//             ],
//           ),

//           const SizedBox(width: 12),

//           /// 👤 Coach Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name + Rating
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         coach.name?.isNotEmpty == true
//                             ? coach.name!
//                             : 'Alexander Montgomery',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: theme.onBackground,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),

//                     Row(
//                       children: [
//                         Text(
//                           coach.rating?.toStringAsFixed(1) ?? "4.5",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: theme.onBackground,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         const Icon(
//                           Icons.star,
//                           color: Color(0xFFFFA500),
//                           size: 18,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),

//                 // Skills chips
//                 Wrap(
//                   spacing: 6,
//                   runSpacing: 6,
//                   children: [
//                     for (final skill in displaySkills)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF5F1ED),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           skill,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xFF4A2E0F),
//                           ),
//                         ),
//                       ),
//                     if (skills.length > 3)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF5F1ED),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           '+${skills.length - 3}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF4A2E0F),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),

//                 const SizedBox(height: 8),

//                 // Starting price
//                 Text(
//                   'Starting form: 100 QRA',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: theme.onBackground,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';

class CoachCard extends StatelessWidget {
  final FeaturedCoachModel coach;
  final VoidCallback? onTapCoachCard;
  final VoidCallback? onFavoriteToggle; // optional for favorite screen
  final bool showFavoriteIcon; // to toggle visibility

  const CoachCard({
    Key? key,
    required this.coach,
    this.onTapCoachCard,
    this.onFavoriteToggle,
    this.showFavoriteIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skills = coach.skills ?? [];
    final displaySkills = skills.take(3).toList();
    final theme = Theme.of(context).colorScheme;

    // ✅ Determine correct image URL
    final imageUrl =
        coach.profileImage?.url ??
        (coach.profileImage?.path != null
            ? 'https://your-api-base-url.com/${coach.profileImage!.path}'
            : null);

    return InkWell(
      onTap: onTapCoachCard,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🟤 Profile image
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/images/coach with image null.jpg')
                        as ImageProvider,
            ),

            const SizedBox(width: 12),

            /// 👤 Coach info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Favorite button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          coach.name?.isNotEmpty == true
                              ? coach.name!
                              : 'Unknown Coach',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: theme.onBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showFavoriteIcon)
                        IconButton(
                          onPressed: onFavoriteToggle,
                          icon: Icon(
                            (coach.isFavorited ?? false)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Rating
                  Row(
                    children: [
                      Text(
                        (coach.rating ?? 0).toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.onBackground,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFA500),
                        size: 16,
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

                  // Starting price placeholder (optional)
                  Text(
                    'Starting from: 100 QAR',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
