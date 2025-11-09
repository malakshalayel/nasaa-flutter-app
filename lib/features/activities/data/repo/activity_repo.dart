import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_result.dart';
import 'package:nasaa/features/activities/data/models/activity_model.dart';
import 'package:nasaa/features/activities/data/services/activity_services.dart';

class ActivityRepo {
  final ActivityServices _services;

  ActivityRepo(this._services);

  Future<List<ActivityModel>> getActivities() async {
    try {
      final response = await _services.getActivity();
      final data = response.data as List<ActivityModel>;
      ApiResult.success(data);
      return data!;
    } catch (e) {
      ApiResult.error(ApiErrorHandler.handelError(e));
      return [];
    }
  }
}
