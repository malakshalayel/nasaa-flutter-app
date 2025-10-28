part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeSuccessState extends HomeState {
  final List<FeaturedCoachModel> coaches;
  final List<ActivityModel> activities;
  final CoachDetails coachDetails;
  HomeSuccessState({
    required this.coaches,
    required this.activities,
    required this.coachDetails,
  });
}

final class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState(this.error);
}
