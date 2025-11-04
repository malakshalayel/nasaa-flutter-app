import 'package:dio/dio.dart';
import 'package:nasaa/core/networking/api_endpoints.dart';
import 'package:nasaa/features/home/data/models/activity_model.dart';
import 'package:nasaa/features/home/data/models/activity_response.dart';
import 'package:nasaa/features/home/data/models/coch_details_response.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:nasaa/features/home/data/models/featured_coachs_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'home_services.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class HomeServices {
  factory HomeServices(Dio dio) = _HomeServices;
  @GET(ApiEndpoints.coachFeatured)
  Future<FeaturedCoachesResponse> getFeaturedCoachesResponse();

  @GET(ApiEndpoints.activity)
  Future<ActivityResponse> getActivity();

  @GET(ApiEndpoints.coachDetails)
  Future<CoachDetailsResponse> getCoachDetails(@Path('id') int id);

  // @GET(ApiEndpoints.coachsIndex)
  // Future<FeaturedCoachesResponse> getCoachsByIndexActivity(
  //   @Query("activity_ids[]") List<int> activitiesId,
  // );
  @GET(ApiEndpoints.coachsIndex)
  Future<FeaturedCoachesResponse> getCoachesWithFilters(
    @Queries() Map<String, dynamic> queries,
  );
}
