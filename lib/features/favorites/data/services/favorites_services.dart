import 'package:dio/dio.dart';
import 'package:nasaa/core/networking/api_endpoints.dart';
import 'package:nasaa/features/favorites/data/model/favorite_model.dart';
import 'package:retrofit/retrofit.dart';

part 'favorites_services.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class FavoritesServices {
  factory FavoritesServices(Dio dio, {String baseUrl}) = _FavoritesServices;

  @POST(ApiEndpoints.favorite)
  Future<dynamic> setFavoriteCoaches(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoints.favorite)
  Future<FavoriteCoachResponse> getFavoriteCoaches();

  @DELETE(ApiEndpoints.favorite + "/{favoriteId}")
  Future<dynamic> removeFavoriteCoache(@Path("favoriteId") int favoriteId);
}
