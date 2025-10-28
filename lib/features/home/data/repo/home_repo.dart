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
      log(data.toString());
      ApiResult.success(data);
      return data!;
    } catch (e) {
      log(e.toString());
      ApiResult.error(ApiErrorHandler.handelError(e));
      return CoachDetails();
    }
  }
}
