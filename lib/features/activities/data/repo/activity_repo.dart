import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_result.dart';
import 'package:nasaa/features/activities/data/models/activity_model.dart';
import 'package:nasaa/features/activities/data/services/activity_services.dart';

class ActivityRepo {
  final ActivityServices _services;

  ActivityRepo(this._services);

  Future<ApiResult<List<ActivityModel>>> getActivities() async {
    try {
      final response = await _services.getActivity();

      return ApiResult.success(response.data);
    } catch (e) {
      return ApiResult.error(ApiErrorHandler.handelError(e));
    }
  }
}
