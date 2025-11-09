import 'package:equatable/equatable.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';

sealed class CoachState extends Equatable {
  const CoachState();

  @override
  List<Object> get props => [];
}

final class CoachInitial extends CoachState {}

final class LoadingCoachState extends CoachState {}

final class LoadedCoachState extends CoachState {
  final List<FeaturedCoachModel> coaches;
  @override
  List<Object> get props => [coaches];
  const LoadedCoachState(this.coaches);
}

final class ErrorCoachState extends CoachState {
  final String message;
  const ErrorCoachState(this.message);
}
