class FavoriteCoachResponse {
  final List<FavoriteCoach> data;

  FavoriteCoachResponse({required this.data});

  factory FavoriteCoachResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return FavoriteCoachResponse(
      data: list.map((e) => FavoriteCoach.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((e) => e.toJson()).toList()};
  }
}

class FavoriteCoach {
  final String id;
  final String FavoriteId;
  final String name;
  final String profileImage;
  final String rating;
  final String skills;
  final String level;
  final String status;
  final String isFavorited;

  FavoriteCoach({
    required this.id,
    required this.FavoriteId,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.skills,
    required this.level,
    required this.status,
    required this.isFavorited,
  });

  factory FavoriteCoach.fromJson(Map<String, dynamic> json) {
    return FavoriteCoach(
      id: json['id'] ?? '',
      FavoriteId: json['Favorite_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      rating: json['rating'] ?? '',
      skills: json['skills'] ?? '',
      level: json['level'] ?? '',
      status: json['status'] ?? '',
      isFavorited: json['is_favorited'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Favorite_id': FavoriteId,
      'name': name,
      'profile_image': profileImage,
      'rating': rating,
      'skills': skills,
      'level': level,
      'status': status,
      'is_favorited': isFavorited,
    };
  }
}
