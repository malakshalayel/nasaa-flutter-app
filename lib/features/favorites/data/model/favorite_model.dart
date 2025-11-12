class FavoriteCoachResponse {
  final List<CoachModel> data;

  FavoriteCoachResponse({required this.data});

  factory FavoriteCoachResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return FavoriteCoachResponse(
      data: list.map((e) => CoachModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((e) => e.toJson()).toList()};
  }
}

// // class FavoriteCoach {
// //   final String id;
// //   final String FavoriteId;
// //   final String name;
// //   final String profileImage;
// //   final double? rating;
// //   final String skills;
// //   final String level;
// //   final String status;
// //   final String isFavorited;

// //   FavoriteCoach({
// //     required this.id,
// //     required this.FavoriteId,
// //     required this.name,
// //     required this.profileImage,
// //     required this.rating,
// //     required this.skills,
// //     required this.level,
// //     required this.status,
// //     required this.isFavorited,
// //   });

// //   factory FavoriteCoach.fromJson(Map<String, dynamic> json) {
// //     return FavoriteCoach(
// //       id: json['id'] ?? '',
// //       FavoriteId: json['Favorite_id'] ?? '',
// //       name: json['name'] ?? '',
// //       profileImage: json['profile_image'] ?? '',
// //       rating: json['rating'] ?? '',
// //       skills: json['skills'] ?? '',
// //       level: json['level'] ?? '',
// //       status: json['status'] ?? '',
// //       isFavorited: json['is_favorited'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'Favorite_id': FavoriteId,
// //       'name': name,
// //       'profile_image': profileImage,
// //       'rating': rating,
// //       'skills': skills,
// //       'level': level,
// //       'status': status,
// //       'is_favorited': isFavorited,
// //     };
// //   }
// // }
// class FavoriteCoach {
//   final int id;
//   final int? userId;
//   final String name;
//   final String profileImage; // ✅ extracted full URL
//   final double? rating;
//   final List<String>? skills;
//   final int? level;
//   final String? status;
//   final bool isFavorited;

//   FavoriteCoach({
//     required this.id,
//     this.userId,
//     required this.name,
//     required this.profileImage,
//     this.rating,
//     this.skills,
//     this.level,
//     this.status,
//     required this.isFavorited,
//   });

//   factory FavoriteCoach.fromJson(Map<String, dynamic> json) {
//     // ✅ Handle nested profile_image map or direct string
//     String imageUrl = '';
//     final imageData = json['profile_image'];
//     if (imageData is Map<String, dynamic>) {
//       // Adjust your base API URL if needed
//       final path = imageData['path'];
//       if (path != null && path is String && path.isNotEmpty) {
//         imageUrl = 'https://your-api-base-url.com/$path'; // change base
//       } else if (imageData['url'] != null) {
//         imageUrl = imageData['url'];
//       }
//     } else if (imageData is String) {
//       imageUrl = imageData;
//     }

//     // ✅ Handle skills field (list or string)
//     List<String>? parsedSkills;
//     if (json['skills'] is List) {
//       parsedSkills = (json['skills'] as List).map((e) => e.toString()).toList();
//     } else if (json['skills'] is String) {
//       parsedSkills = json['skills'].split(',');
//     }

//     return FavoriteCoach(
//       id: json['id'] is String
//           ? int.tryParse(json['id']) ?? 0
//           : (json['id'] ?? 0),
//       userId: json['user_id'] is String
//           ? int.tryParse(json['user_id'])
//           : json['user_id'],
//       name: json['name']?.toString() ?? '',
//       profileImage: imageUrl,
//       rating: (json['rating'] is num)
//           ? (json['rating'] as num).toDouble()
//           : double.tryParse(json['rating']?.toString() ?? ''),
//       skills: parsedSkills,
//       level: json['level'] is String
//           ? int.tryParse(json['level'])
//           : json['level'],
//       status: json['status']?.toString(),
//       isFavorited:
//           json['is_favorited'] == true ||
//           json['is_favorited'].toString().toLowerCase() == 'true' ||
//           json['is_favorited'] == 1,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'name': name,
//       'profile_image': profileImage,
//       'rating': rating,
//       'skills': skills,
//       'level': level,
//       'status': status,
//       'is_favorited': isFavorited,
//     };
//   }
// }
class CoachModel {
  final int id;
  final int? userId;
  final String name;
  final ProfileImage? profileImage; // nested object
  final double? rating;
  final List<String>? skills;
  final int? level;
  final String? status;
  final bool isFavorited;

  CoachModel({
    required this.id,
    this.userId,
    required this.name,
    this.profileImage,
    this.rating,
    this.skills,
    this.level,
    this.status,
    required this.isFavorited,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : (json['id'] ?? 0),
      userId: json['user_id'] is String
          ? int.tryParse(json['user_id'])
          : json['user_id'],
      name: json['name']?.toString() ?? '',
      profileImage:
          json['profile_image'] != null &&
              json['profile_image'] is Map<String, dynamic>
          ? ProfileImage.fromJson(json['profile_image'])
          : null,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? ''),
      skills: (json['skills'] is List)
          ? (json['skills'] as List).map((e) => e.toString()).toList()
          : (json['skills'] is String
                ? json['skills'].split(',').map((e) => e.trim()).toList()
                : null),
      level: json['level'] is String
          ? int.tryParse(json['level'])
          : json['level'],
      status: json['status']?.toString(),
      isFavorited:
          json['is_favorited'] == true ||
          json['is_favorited'].toString().toLowerCase() == 'true' ||
          json['is_favorited'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'profile_image': profileImage?.toJson(),
      'rating': rating,
      'skills': skills,
      'level': level,
      'status': status,
      'is_favorited': isFavorited,
    };
  }

  /// ✅ Helper: get direct usable image URL for the card widget
  String get imageUrl {
    if (profileImage == null) return '';
    if (profileImage!.url != null && profileImage!.url!.isNotEmpty) {
      return profileImage!.url!;
    }
    if (profileImage!.path != null && profileImage!.path!.isNotEmpty) {
      return 'https://your-api-base-url.com/${profileImage!.path}';
    }
    return '';
  }
}

class ProfileImage {
  final int? id;
  final String? attachableType;
  final int? attachableId;
  final int? attachmentType;
  final int? userId;
  final String? filename;
  final String? path;
  final String? fileExtension;
  final int? filesize;
  final String? deletedAt;
  final String? createdAt;
  final dynamic attachmentAttributes;
  final String? url;

  ProfileImage({
    this.id,
    this.attachableType,
    this.attachableId,
    this.attachmentType,
    this.userId,
    this.filename,
    this.path,
    this.fileExtension,
    this.filesize,
    this.deletedAt,
    this.createdAt,
    this.attachmentAttributes,
    this.url,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'],
      attachableType: json['attachable_type'],
      attachableId: json['attachable_id'],
      attachmentType: json['attachment_type'],
      userId: json['user_id'],
      filename: json['filename'],
      path: json['path'],
      fileExtension: json['file_extension'],
      filesize: json['filesize'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      attachmentAttributes: json['attachment_attributes'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attachable_type': attachableType,
      'attachable_id': attachableId,
      'attachment_type': attachmentType,
      'user_id': userId,
      'filename': filename,
      'path': path,
      'file_extension': fileExtension,
      'filesize': filesize,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'attachment_attributes': attachmentAttributes,
      'url': url,
    };
  }
}
