import 'dart:developer';

class CoachDetailsResponse {
  final CoachDetails? data;

  CoachDetailsResponse({this.data});

  factory CoachDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CoachDetailsResponse(
      data: json['data'] != null ? CoachDetails.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {'data': data?.toJson()};
}

class CoachDetails {
  final int? id;
  final int? userId;
  final String? name;
  final UserProfile? userProfile;
  final int? numberOfReviews;
  final String? avgRating;
  final int? level;
  final String? yearsOfExperience;
  final List<Activity>? activities;
  final String? about;
  final bool? isFavorited;
  final List<dynamic>? availableDays;
  final List<TrainingLocation>? trainingLocations;
  final Nationality? nationality;
  final City? city;
  final List<Language>? languages;
  final List<Certificate>? certificates;
  final IdImage? idImage;
  final String? status;
  final List<ExtraFeature>? extraFeatures;

  CoachDetails({
    this.id,
    this.userId,
    this.name,
    this.userProfile,
    this.numberOfReviews,
    this.avgRating,
    this.level,
    this.yearsOfExperience,
    this.activities,
    this.about,
    this.isFavorited,
    this.availableDays,
    this.trainingLocations,
    this.nationality,
    this.city,
    this.languages,
    this.certificates,
    this.idImage,
    this.status,
    this.extraFeatures,
  });

  factory CoachDetails.fromJson(Map<String, dynamic> json) {
    return CoachDetails(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      userProfile: json['user_profile'] != null
          ? UserProfile.fromJson(json['user_profile'])
          : null,
      numberOfReviews: json['number_of_reviews'],
      avgRating: json['avg_rating']?.toString(), // ✅ safe for int or string
      level: json['level'] is int
          ? json['level']
          : int.tryParse(json['level']?.toString() ?? ''),
      yearsOfExperience: json['years_of_experience']?.toString(),
      activities: (json['activities'] as List?)
          ?.map((e) => Activity.fromJson(e))
          .toList(),
      about: json['about'],
      isFavorited:
          json['is_favorited'] == true ||
          json['is_favorited'].toString().toLowerCase() == 'true',
      availableDays: json['available_days'] ?? [],
      trainingLocations: (json['training_locations'] as List?)
          ?.map((e) => TrainingLocation.fromJson(e))
          .toList(),
      nationality: json['nationality'] != null
          ? Nationality.fromJson(json['nationality'])
          : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      languages: (json['languages'] as List?)
          ?.map((e) => Language.fromJson(e))
          .toList(),
      certificates: (json['certificates'] as List?)
          ?.map((e) => Certificate.fromJson(e))
          .toList(),
      idImage: json['id_image'] != null
          ? IdImage.fromJson(json['id_image'])
          : null,
      status: json['status'],
      extraFeatures: (json['extra_features'] as List?)
          ?.map((e) => ExtraFeature.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'user_profile': userProfile?.toJson(),
    'number_of_reviews': numberOfReviews,
    'avg_rating': avgRating,
    'level': level,
    'years_of_experience': yearsOfExperience,
    'activities': activities?.map((e) => e.toJson()).toList(),
    'about': about,
    'is_favorited': isFavorited,
    'available_days': availableDays,
    'training_locations': trainingLocations?.map((e) => e.toJson()).toList(),
    'nationality': nationality?.toJson(),
    'city': city?.toJson(),
    'languages': languages?.map((e) => e.toJson()).toList(),
    'certificates': certificates?.map((e) => e.toJson()).toList(),
    'id_image': idImage?.toJson(),
    'status': status,
    'extra_features': extraFeatures?.map((e) => e.toJson()).toList(),
  };
}

// ────────────────────────────── Nested Models ──────────────────────────────

class UserProfile {
  final String? filename;
  final String? url;
  final dynamic attributes; // Can be String or Map

  UserProfile({this.filename, this.url, this.attributes});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      filename: json['filename'],
      url: json['url'],
      attributes: json['attributes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'filename': filename,
    'url': url,
    'attributes': attributes,
  };
}

class TrainingLocation {
  final int? id;
  final int? coachId;
  final String? type;
  final String? latitude;
  final String? longitude;
  final String? deletedAt;
  final String? createdAt;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressLabel;
  final String? area;
  final int? cityId;
  final bool? isActive;

  TrainingLocation({
    this.id,
    this.coachId,
    this.type,
    this.latitude,
    this.longitude,
    this.deletedAt,
    this.createdAt,
    this.addressLine1,
    this.addressLine2,
    this.addressLabel,
    this.area,
    this.cityId,
    this.isActive,
  });

  factory TrainingLocation.fromJson(Map<String, dynamic> json) {
    return TrainingLocation(
      id: json['id'],
      coachId: json['coach_id'],
      type: json['type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      addressLabel: json['address_label'],
      area: json['area'],
      cityId: json['city_id'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'coach_id': coachId,
    'type': type,
    'latitude': latitude,
    'longitude': longitude,
    'deleted_at': deletedAt,
    'created_at': createdAt,
    'address_line1': addressLine1,
    'address_line2': addressLine2,
    'address_label': addressLabel,
    'area': area,
    'city_id': cityId,
    'is_active': isActive,
  };
}

class Nationality {
  final int? id;
  final String? name;

  Nationality({this.id, this.name});

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class City {
  final int? id;
  final String? name;
  final Country? country;

  City({this.id, this.name, this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    try {
      return City(
        id: json['id'],
        name: json['name'],
        country: json['country'] != null
            ? Country.fromJson(json['country'])
            : null,
      );
    } catch (e) {
      log('❌ Error parsing City: $e');
      return City(id: json['id'], name: json['name'], country: null);
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country?.toJson(),
  };
}

class Country {
  final String? id; // Keep as String to match schema
  final String? name;

  Country({this.id, this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    try {
      return Country(
        // ✅ Handle both int and String for id
        id: json['id']?.toString(), // Convert to String regardless of type
        name: json['name'],
      );
    } catch (e) {
      log('❌ Error parsing Country: $e');
      return Country();
    }
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Language {
  final int? id;
  final String? name;
  final String? code;
  final String? deletedAt;
  final String? createdAt;

  Language({this.id, this.name, this.code, this.deletedAt, this.createdAt});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'deleted_at': deletedAt,
    'created_at': createdAt,
  };
}

class Certificate {
  final String? filename;
  final String? url;
  final dynamic attributes; // ✅ Can be String, Map, or null

  Certificate({this.filename, this.url, this.attributes});

  factory Certificate.fromJson(Map<String, dynamic> json) {
    try {
      return Certificate(
        filename: json['filename'],
        url: json['url'],
        // Keep as dynamic - can be String or Map
        attributes: json['attributes'],
      );
    } catch (e) {
      log('❌ Error parsing Certificate: $e');
      return Certificate();
    }
  }

  Map<String, dynamic> toJson() => {
    'filename': filename,
    'url': url,
    'attributes': attributes,
  };
}

class IdImage {
  final String? filename;
  final String? url;
  final dynamic attributes; // Can be String or Map

  IdImage({this.filename, this.url, this.attributes});

  factory IdImage.fromJson(Map<String, dynamic> json) {
    return IdImage(
      filename: json['filename'],
      url: json['url'],
      attributes: json['attributes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'filename': filename,
    'url': url,
    'attributes': attributes,
  };
}

class ExtraFeature {
  final String? extraFeature;

  ExtraFeature({this.extraFeature});

  factory ExtraFeature.fromJson(Map<String, dynamic> json) {
    return ExtraFeature(extraFeature: json['extra_feature']);
  }

  Map<String, dynamic> toJson() => {'extra_feature': extraFeature};
}

// "activities": [
//       {
//         "id": 1,
//         "name": "Body Building",
//         "rating_avg": "5.0000",
//         "icon_svg": "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"feather feather-dumbbell\"><line x1=\"6\" y1=\"6\" x2=\"6\" y2=\"18\"></line><line x1=\"18\" y1=\"6\" x2=\"18\" y2=\"18\"></line><line x1=\"3\" y1=\"12\" x2=\"21\" y2=\"12\"></line></svg>",
//         "reviews_count": 2,
//         "years_of_experiance": "10+ years"
//       }
//     ],

class Activity {
  final int? id;
  final String? name;
  final String? ratingAvg;
  final String? iconSvg;
  final int? reviewsCount;
  final String? yearsOfExperience;

  Activity({
    this.id,
    this.name,
    this.ratingAvg,
    this.iconSvg,
    this.reviewsCount,
    this.yearsOfExperience,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name']?.toString(),
      ratingAvg: json['rating_avg']?.toString(),
      iconSvg: json['icon_svg']?.toString(),
      reviewsCount: json['reviews_count'] is int
          ? json['reviews_count']
          : int.tryParse(json['reviews_count']?.toString() ?? '0'),
      yearsOfExperience: json['years_of_experiance']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rating_avg': ratingAvg,
    'icon_svg': iconSvg,
    'reviews_count': reviewsCount,
    'years_of_experiance': yearsOfExperience,
  };
}
