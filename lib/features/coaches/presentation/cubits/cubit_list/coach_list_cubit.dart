import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';
import 'package:nasaa/features/coaches/data/repo/coach_repo.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_state.dart';

class CoachCubit extends Cubit<CoachState> {
  CoachCubit(this._repo) : super(CoachInitial());
  CoachRepo _repo;
  List<FeaturedCoachModel> coaches = [];

  Future<void> getCoaches() async {
    if (isClosed) return;

    emit(LoadingCoachState());

    try {
      final result = await _repo.getCoaches();
      if (isClosed) return;
      result.when(
        onSuccess: (data) {
          coaches = data;
          emit(LoadedCoachState(coaches));
        },
        onError: (error) =>
            emit(ErrorCoachState(ApiErrorHandler.handelError(error))),
      );
    } catch (e) {
      emit(ErrorCoachState(e.toString()));
    }
  }

  Future<void> refresh() async {
    await getCoaches();
  }

  Future<void> getCoachesWithFilters(Map<String, dynamic> queries) async {
    if (isClosed) return;
    emit(LoadingCoachState());
    try {
      final result = await _repo.getCoachesWithFilter(queries);
      if (isClosed) return;
      result.when(
        onSuccess: (data) {
          coaches = data;
          emit(LoadedCoachWithFilterState(coaches));
        },
        onError: (errror) => emit(ErrorCoachState(errror.toString())),
      );
    } catch (e) {
      emit(ErrorCoachState(e.toString()));
    }
  }
}
