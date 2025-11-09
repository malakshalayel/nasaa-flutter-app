import 'package:equatable/equatable.dart';
import 'package:nasaa/features/activities/data/models/activity_model.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialActivityState extends ActivityState {}

class LoadingActivityState extends ActivityState {}

class LoadedActivityState extends ActivityState {
  final List<ActivityModel> activities;
  const LoadedActivityState(this.activities);

  @override
  // TODO: implement props
  List<Object?> get props => [activities];
}

class ErrorActivityState extends ActivityState {
  final String message;
  const ErrorActivityState(this.message);
}
