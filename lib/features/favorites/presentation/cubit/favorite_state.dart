import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoaded extends FavoriteState {
  final Set<int> favoriteIds;

  const FavoriteLoaded({required this.favoriteIds});

  bool isFavorite(int coachId) => favoriteIds.contains(coachId);

  FavoriteLoaded copyWith({Set<int>? favoriteIds}) {
    return FavoriteLoaded(favoriteIds: favoriteIds ?? this.favoriteIds);
  }

  @override
  List<Object?> get props => [favoriteIds];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
