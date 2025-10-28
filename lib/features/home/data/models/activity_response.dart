import 'package:nasaa/features/home/data/models/activity_model.dart';

class ActivityResponse {
  final List<ActivityModel> data;

  ActivityResponse({required this.data});

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      data: (json['data'] as List)
          .map((e) => ActivityModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
  };
}
