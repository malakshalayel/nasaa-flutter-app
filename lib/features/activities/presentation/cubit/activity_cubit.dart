import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/features/activities/data/models/activity_model.dart';
import 'package:nasaa/features/activities/data/repo/activity_repo.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit(this._repo) : super(InitialActivityState());
  final ActivityRepo _repo;
  List<ActivityModel> activities = [];

  Future<void> getActivities() async {
    if (isClosed) return;
    emit(LoadingActivityState());

    try {
      final result = await _repo.getActivities();

      if (isClosed) return;

      result.when(
        onSuccess: (data) {
          activities = data;
          emit(LoadedActivityState(activities));
        },
        onError: (error) {
          emit(
            ErrorActivityState(error.message ?? 'Failed to load activities'),
          );
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ErrorActivityState(e.toString()));
      }
    }
  }

  void sortByNewest() {
    if (state is LoadedActivityState) {
      // ✅ Create new list to avoid mutation issues
      final sorted = List<ActivityModel>.from(activities)
        ..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      activities = sorted;
      emit(LoadedActivityState(List.from(activities)));
    }
  }

  void sortByOldest() {
    if (state is LoadedActivityState) {
      final sorted = List<ActivityModel>.from(activities)
        ..sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      activities = sorted;
      emit(LoadedActivityState(List.from(activities)));
    }
  }

  void sortAlphabetically() {
    if (state is LoadedActivityState) {
      final sorted = List<ActivityModel>.from(activities)
        ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
      activities = sorted;
      emit(LoadedActivityState(List.from(activities)));
    }
  }

  Future<void> refresh() async {
    await getActivities();
  }
}
