// {
//   "message": "Coach added to favorites",
//   "data": "string"
// }
// make it stable for retrofit lib to work

class FavoriteModelResponse {
  String? message;
  String? data;

  FavoriteModelResponse({required this.message, required this.data});

  factory FavoriteModelResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteModelResponse(
      message: json['message']?.toString(),
      data: json['data']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data;
    return _data;
  }
}
