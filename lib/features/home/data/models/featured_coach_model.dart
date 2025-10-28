class FeaturedCoachModel {
  final int? id;
  final int? userId;
  final String? name;
  final ProfileImage? profileImage;
  final String? rating;
  final List<String>? skills;
  final int? level;
  final String? status;
  final bool? isFavorited;

  FeaturedCoachModel({
    this.id,
    this.userId,
    this.name,
    this.profileImage,
    this.rating,
    this.skills,
    this.level,
    this.status,
    this.isFavorited,
  });

  factory FeaturedCoachModel.fromJson(Map<String, dynamic> json) {
    return FeaturedCoachModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      profileImage: json['profile_image'] != null
          ? ProfileImage.fromJson(json['profile_image'])
          : null,
      rating: json['rating']?.toString(),
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList(),
      level: json['level'],
      status: json['status'],
      isFavorited: json['is_favorited'] ?? false,
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
