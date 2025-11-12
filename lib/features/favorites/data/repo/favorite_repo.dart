import 'dart:ffi';

import 'package:nasaa/core/check_internet_connection.dart';
import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_result.dart';
import 'package:nasaa/features/favorites/data/model/favorite_model.dart';
import 'package:nasaa/features/favorites/data/services/favorites_services.dart';

class FavoriteRepo {
  FavoritesServices services;
  FavoriteRepo(this.services);

  Future<ApiResult<bool>> addCoachToFavorites(int coachId) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      return await services.setFavoriteCoaches({"coach_id": coachId}).then((
        value,
      ) {
        if (value["message"] == "Coach added to favorites") {
          return ApiResult.success(true);
        } else {
          return ApiResult.error(value["message"]);
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ApiResult<Set<int>>> getFavoriteCoachesids() async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      return services
          .getFavoriteCoaches()
          .then((response) {
            final coaches = response as List<CoachModel>;
            final ids = coaches.map((e) => int.parse(e.id.toString())).toSet();
            return ApiResult.success(ids);
          })
          .catchError((e) {
            return ApiResult<Set<int>>.error(ApiErrorHandler.handelError(e));
          });
    } catch (e) {
      return ApiResult<Set<int>>.error(ApiErrorHandler.handelError(e));
    }
  }

  Future<ApiResult<bool>> removeCoachFromFavorites(int coachId) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      return await services.removeFavoriteCoache(coachId).then((response) {
        if (response["message"] == "Coach removed from favorites") {
          return ApiResult.success(true);
        } else {
          return ApiResult.error(
            ApiErrorHandler.handelError(response["message"]),
          );
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
