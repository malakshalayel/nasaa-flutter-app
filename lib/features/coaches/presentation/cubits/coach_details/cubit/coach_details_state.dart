import 'package:equatable/equatable.dart';
import 'package:nasaa/features/coaches/data/models/coch_details_response.dart';

sealed class CoachDetailsState extends Equatable {
  const CoachDetailsState();

  @override
  List<Object> get props => [];
}

final class CoachDetailsInitial extends CoachDetailsState {}

final class CoachDetailsLoading extends CoachDetailsState {}

final class CoachDetailsLoaded extends CoachDetailsState {
  final CoachDetails coachDetails;
  const CoachDetailsLoaded(this.coachDetails);
  @override
  // TODO: implement props
  List<Object> get props => [coachDetails];
}

final class CoachDetailsError extends CoachDetailsState {
  final String message;
  const CoachDetailsError(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
