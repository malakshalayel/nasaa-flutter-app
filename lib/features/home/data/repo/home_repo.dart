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

  // Store favorites as a class variable
  List<FeaturedCoachModel> _favoriteCoaches = [];

  Future<List<FeaturedCoachModel>> addOrRemoveFromFavorite(
    int id,
    FeaturedCoachModel coach, // Pass the full coach object
  ) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      // Check if coach is already in favorites
      final index = _favoriteCoaches.indexWhere((c) => c.id == id);

      if (index != -1) {
        // Coach exists - remove it
        _favoriteCoaches.removeAt(index);
        log("Removed coach $id from favorites");
      } else {
        // Coach doesn't exist - add it
        _favoriteCoaches.add(coach);
        log("Added coach $id to favorites");
      }

      return List.from(_favoriteCoaches); // Return a copy
    } catch (e) {
      log("Error in addOrRemoveFromFavorite: $e");
      throw e;
    }
  }

  // Get all favorites
  List<FeaturedCoachModel> getFavoriteCoaches() {
    return List.from(_favoriteCoaches);
  }

  Future<bool> setFavoriteCoaches(int coachId) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      final response = await _services.setFavoriteCoaches({
        "coach_id": coachId,
      });

      // Validate the response (you can check id, message, anything)
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      print("setFavoriteCoaches error: $e");
      return false;
    }
  }

  Future<bool> removeFavoriteCoaches(int coachId) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      final response = await _services.removeFavoriteCoache(coachId);
      return true;
    } catch (e) {
      print("removeFavoriteCoaches error: $e");
      return false;
    }
  }
}
