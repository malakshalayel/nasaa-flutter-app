part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeSuccessState extends HomeState {
  final List<FeaturedCoachModel> coaches;
  final List<ActivityModel> activities;
  final List<FeaturedCoachModel> coachesByActivity;
  final CoachDetails coachDetails;
  final List<FeaturedCoachModel> favoriteCoches;

  HomeSuccessState({
    required this.coaches,
    required this.activities,
    required this.coachDetails,
    required this.coachesByActivity,
    required this.favoriteCoches,
  });

  HomeSuccessState copyWith({
    List<FeaturedCoachModel>? coaches,
    List<ActivityModel>? activities,
    List<FeaturedCoachModel>? coachesByActivity,
    List<FeaturedCoachModel>? favoriteCoches,
    CoachDetails? coachDetails,
  }) {
    return HomeSuccessState(
      coaches: coaches ?? this.coaches,
      activities: activities ?? this.activities,
      coachesByActivity: coachesByActivity ?? this.coachesByActivity,
      coachDetails: coachDetails ?? this.coachDetails,
      favoriteCoches: favoriteCoches ?? this.favoriteCoches,
    );
  }
}

final class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState(this.error);
}
