import 'dart:developer';

import 'package:nasaa/core/check_internet_connection.dart';
import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_result.dart';
import 'package:nasaa/features/coaches/data/models/coch_details_response.dart';
import 'package:nasaa/features/coaches/data/services.dart/coach_services.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';

class CoachRepo {
  CoachServices _services;
  CoachRepo(this._services);

  Future<ApiResult<List<FeaturedCoachModel>>> getFeaturedCoaches() async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }
    try {
      return _services
          .getFeaturedCoaches()
          .then((response) {
            final coaches = response.data ?? [];
            return ApiResult<List<FeaturedCoachModel>>.success(coaches);
          })
          .catchError((e) {
            return ApiResult<List<FeaturedCoachModel>>.error(
              ApiErrorHandler.handelError(e),
            );
          });
    } catch (e) {
      return ApiResult.error(ApiErrorHandler.handelError(e));
    }
  }

  Future<ApiResult<CoachDetails>> getCoachDetails(int id) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }
    try {
      return await _services
          .getCoachDetails(id)
          .then((response) {
            final coachDetails = response.data;
            return ApiResult<CoachDetails>.success(
              coachDetails as CoachDetails,
            );
          })
          .catchError((e) async {
            log(e.toString());
            return await ApiResult<CoachDetails>.error(
              ApiErrorHandler.handelError(e),
            );
          });
    } catch (e) {
      return ApiResult.error(ApiErrorHandler.handelError(e));
    }
  }

  Future<ApiResult<List<FeaturedCoachModel>>> getCoachesWithFilter(
    Map<String, dynamic> queries,
  ) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      final filterQuieries = _formatQueryParams(queries);
      return _services
          .getCoachesWithFilters(filterQuieries)
          .then((response) {
            return ApiResult.success(response.data ?? []);
          })
          .catchError(
            (e) => ApiResult<List<FeaturedCoachModel>>.error(
              ApiErrorHandler.handelError(e),
            ),
          );
    } catch (e) {
      return ApiResult.error(ApiErrorHandler.handelError(e));
    }
  }

  Map<String, dynamic> _formatQueryParams(Map<String, dynamic> params) {
    final formated = <String, dynamic>{};
    params.forEach((key, value) {
      if (value == null) return;

      if (value is List && value.isNotEmpty) {
        formated['$key[]'] = value;
      } else if (value is! List) {
        formated[key] = value;
      }
    });

    return formated;
  }
}
