//     {
//       "id": 1,
//       "name": "Body Building",
//       "icon": "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"feather feather-dumbbell\"><line x1=\"6\" y1=\"6\" x2=\"6\" y2=\"18\"></line><line x1=\"18\" y1=\"6\" x2=\"18\" y2=\"18\"></line><line x1=\"3\" y1=\"12\" x2=\"21\" y2=\"12\"></line></svg>",
//       "deleted_at": null,
//       "created_at": "2025-10-21T07:01:08.000000Z"
//     },

class ActivityModel {
  int? id;
  String? name;
  String? icon;
  String? deletedAt;
  String? createdAt;
  ActivityModel({
    this.id,
    this.name,
    this.icon,
    this.deletedAt,
    this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json["id"],
      name: json['name'],
      icon: json['icon'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['icon'] = icon;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    return map;
  }
}
