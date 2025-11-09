import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/features/coaches/data/models/coch_details_response.dart';
import 'package:nasaa/features/coaches/data/repo/coach_repo.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_state.dart';

class CoachDetailsCubit extends Cubit<CoachDetailsState> {
  CoachDetailsCubit({required this.coachId, required CoachRepo repo})
    : _repo = repo,
      super(CoachDetailsInitial());

  CoachRepo _repo;

  CoachDetails? coachDetails;
  final int coachId;

  Future<void> getCoachDetails() async {
    if (isClosed) return;

    emit(CoachDetailsLoading());
    try {
      final result = await _repo.getCoachDetails(coachId);
      if (isClosed) return;
      result.when(
        onSuccess: (data) {
          coachDetails = data;
          emit(CoachDetailsLoaded(data));
        },
        onError: (error) => emit(CoachDetailsError(error.toString())),
      );
    } catch (e) {
      emit(CoachDetailsError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await getCoachDetails();
  }
}
