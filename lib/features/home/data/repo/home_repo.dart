import 'dart:developer';

import 'package:nasaa/core/check_internet_connection.dart';
import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_result.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/features/home/data/models/activity_model.dart';
import 'package:nasaa/features/home/data/models/coch_details_response.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:nasaa/features/home/data/services/home_services.dart';

class HomeRepo {
  final HomeServices _services;

  // Constructor injection
  HomeRepo(this._services);

  // Factory or initializer if you want to use DioFactory here directly
  factory HomeRepo.create() {
    final dio = DioFactory().dio;
    final services = HomeServices(dio);
    return HomeRepo(services);
  }

  Future<List<FeaturedCoachModel>> getCoaches() async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      final response = await _services.getFeaturedCoachesResponse();
      final data = response.data;

      log(data.toString());
      ApiResult.success(data);
      return data!;
    } catch (e) {
      log(e.toString());
      ApiResult.error(ApiErrorHandler.handelError(e));
      return [];
    }
  }

  Future<List<ActivityModel>> getActivity() async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      final response = await _services.getActivity();
      final data = response.data;
      log(data.first.toString());
      ApiResult.success(data);
      return data;
    } catch (e) {
      log(e.toString());
      ApiResult.error(ApiErrorHandler.handelError(e));
      return [];
    }
  }

  Future<CoachDetails> getCoachDetails(int id) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      final response = await _services.getCoachDetails(id);
      final data = response.data;
      log('coach details in repo ' + data.toString());
      log('✅ Coach name parsed: ${data?.name}');
      ApiResult.success(data);
      return data!;
    } catch (e) {
      log(e.toString());
      ApiResult.error(ApiErrorHandler.handelError(e));
      return CoachDetails();
    }
  }

  // Future<List<FeaturedCoachModel>> getCoachsByIndexActivity(
  //   List<int> activityIds,
  // ) async {
  //   if (!await checkInternetConnection()) {
  //     throw Exception("No Internet Connection");
  //   }

  //   try {
  //     final response = await _services.getCoachsByIndexActivity(activityIds);
  //     log('coachs by index response: ' + response.data.toString());
  //     ApiResult.success(response.data);
  //     return response.data!;
  //   } catch (e) {
  //     log(e.toString());
  //     ApiResult.error(ApiErrorHandler.handelError(e));
  //     return [];
  //   }
  // }

  Future<List<FeaturedCoachModel>> getCoachesWithFilters(
    Map<String, dynamic> filterParams,
  ) async {
    log('🔍 Fetching coaches with filters: $filterParams');

    // Format arrays properly for API
    final queries = _formatQueryParams(filterParams);

    // queries = {
    //   'rating': 4.5,
    //   'gender': 1,
    //   'min_price': 50,
    //   'max_price': 200,
    //   'extra_features[]': ['family'],
    //   'activity_ids[]': [1],
    //   'sort_by': 'rating_desc'
    // }

    final response = await _services.getCoachesWithFilters(queries);

    return response.data ?? [];
  }

  Map<String, dynamic> _formatQueryParams(Map<String, dynamic> params) {
    final formatted = <String, dynamic>{};

    params.forEach((key, value) {
      if (value == null) return;

      if (value is List && value.isNotEmpty) {
        // Format arrays as 'key[]' for Retrofit
        formatted['$key[]'] = value;
      } else if (value is! List) {
        formatted[key] = value;
      }
    });

    return formatted;
  }
}
