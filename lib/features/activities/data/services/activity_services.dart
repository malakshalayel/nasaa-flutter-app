import 'package:dio/dio.dart';
import 'package:nasaa/core/networking/api_endpoints.dart';
import 'package:nasaa/features/activities/data/models/activity_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'activity_services.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ActivityServices {
  factory ActivityServices(Dio dio, {String baseUrl}) = _ActivityServices;

  @GET(ApiEndpoints.activity)
  Future<ActivityResponse> getActivity();
}
