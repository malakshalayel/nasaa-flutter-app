import 'package:dio/dio.dart';
import 'package:nasaa/core/networking/api_endpoints.dart';
import 'package:nasaa/features/coaches/data/models/coch_details_response.dart';
import 'package:nasaa/features/coaches/data/models/featured_coachs_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'coach_services.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class CoachServices {
  factory CoachServices(Dio dio, {String baseUrl}) = _CoachServices;

  @GET(ApiEndpoints.coachFeatured)
  Future<FeaturedCoachesResponse> getFeaturedCoaches();

  @GET(ApiEndpoints.coachDetails)
  Future<CoachDetailsResponse> getCoachDetails(@Path('id') int id);

  @GET(ApiEndpoints.coachsIndex)
  Future<FeaturedCoachesResponse> getCoachesWithFilters(
    @Queries() Map<String, dynamic> queries,
  );
}
