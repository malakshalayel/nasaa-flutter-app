import 'package:nasaa/features/login/data/models/customer_model_api.dart';

class User {
  final int? id;
  final int? type;
  final String? phone;
  final String? name;
  final String? email;
  final String? locale;
  final String? gender;
  final String? dob;
  final int? nationalityId;
  final int? cityId;
  final int? status;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final bool? isComplete;
  final bool? isCustomer;
  final bool? isCoach;
  final bool? isAdmin;
  final String? profileImage;
  final Customer? customer;

  User({
    this.id,
    this.type,
    this.phone,
    this.name,
    this.email,
    this.locale,
    this.gender,
    this.dob,
    this.nationalityId,
    this.cityId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.isComplete,
    this.isCustomer,
    this.isCoach,
    this.isAdmin,
    this.profileImage,
    this.customer,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      type: json['type'],
      phone: json['phone'],
      name: json['name'],
      email: json['email'],
      locale: json['locale'],
      gender: json['gender'],
      dob: json['dob'],
      nationalityId: json['nationality_id'],
      cityId: json['city_id'],
      status: json['status'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isComplete: json['is_complete'],
      isCustomer: json['is_customer'],
      isCoach: json['is_coach'],
      isAdmin: json['is_admin'],
      profileImage: json['profile_image'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'type': type,
      'phone': phone,
      'name': name,
      'email': email,
      'locale': locale,
      'gender': gender,
      'dob': dob,
      'nationality_id': nationalityId,
      'city_id': cityId,
      'status': status,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_complete': isComplete,
      'is_customer': isCustomer,
      'is_coach': isCoach,
      'is_admin': isAdmin,
      'profile_image': profileImage,
    };
    if (customer != null) map['customer'] = customer!.toJson();
    return map;
  }
}
