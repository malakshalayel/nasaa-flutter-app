// import 'package:flutter/material.dart';
// import 'package:nasaa/features/favorites/data/model/favorite_model.dart';

// class FavoriteCoachCard extends StatelessWidget {
//   final FavoriteCoach coach;
//   final VoidCallback? onFavoriteToggle;
//   final VoidCallback? onTap;

//   const FavoriteCoachCard({
//     Key? key,
//     required this.coach,
//     this.onFavoriteToggle,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isFavorited = coach.isFavorited == 'true' || coach.isFavorited == '1';

//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               // Profile image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: coach.profileImage.isNotEmpty
//                     ? Image.network(
//                         coach.profileImage,

//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       )
//                     : Image.asset(
//                         'assets/images/coach with image null.jpg',
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//               ),

//               const SizedBox(width: 16),

//               // Details section
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Name + Favorite button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             coach.name,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             isFavorited
//                                 ? Icons.favorite
//                                 : Icons.favorite_border,
//                             color: Colors.redAccent,
//                           ),
//                           onPressed: onFavoriteToggle,
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 4),

//                     // Rating bar
//                     if (coach.rating != null)
//                       // RatingBarIndicator(
//                       //   rating: coach.rating ?? 0.0,
//                       //   itemBuilder: (context, index) => const Icon(
//                       //     Icons.star,
//                       //     color: Colors.amber,
//                       //   ),
//                       //   itemCount: 5,
//                       //   itemSize: 18,
//                       //   direction: Axis.horizontal,
//                       // ),
//                       const SizedBox(height: 4),

//                     // Skills
//                     Text(
//                       coach.skills,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),

//                     const SizedBox(height: 6),

//                     // Level + Status
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             coach.level,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           coach.status,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: coach.status.toLowerCase() == 'online'
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
