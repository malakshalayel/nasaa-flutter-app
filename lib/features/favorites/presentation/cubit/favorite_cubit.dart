import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nasaa/features/favorites/data/repo/favorite_repo.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo _repository;

  FavoriteCubit(this._repository) : super(const FavoriteInitial()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final response = await _repository.getFavoriteCoachesids();
      response.when(
        onSuccess: (ids) => emit(FavoriteLoaded(favoriteIds: ids)),
        onError: (message) => emit(const FavoriteLoaded(favoriteIds: {})),
      );
    } catch (e) {
      emit(const FavoriteLoaded(favoriteIds: {}));
    }
  }

  Future<void> toggleFavorite(int coachId) async {
    final currentState = state;

    if (currentState is! FavoriteLoaded) return;

    final updatedIds = Set<int>.from(currentState.favoriteIds);
    final wasAdded = !updatedIds.remove(coachId);

    if (wasAdded) {
      updatedIds.add(coachId);
    }

    emit(currentState.copyWith(favoriteIds: updatedIds));

    try {
      final success = wasAdded
          ? await _repository.addCoachToFavorites(coachId)
          : await _repository.removeCoachFromFavorites(coachId);

      success.when(
        onSuccess: (message) => emit(FavoriteLoaded(favoriteIds: updatedIds)),
        onError: (message) => emit(currentState),
      );
    } catch (e) {
      emit(currentState);
    }
  }

  bool isFavorite(int coachId) {
    final currentState = state;
    if (currentState is FavoriteLoaded) {
      return currentState.isFavorite(coachId);
    }
    return false;
  }
}
