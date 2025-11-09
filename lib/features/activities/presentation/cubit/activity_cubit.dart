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
      activities = await _repo.getActivities();
      emit(LoadedActivityState(activities));
    } catch (e) {
      if (isClosed) emit(ErrorActivityState(e.toString()));
    }
  }

  void sortByNewst() {
    if (state is LoadedActivityState) {
      final sorted = List<ActivityModel>.from(
        activities..sort(
          (activity1, activity2) =>
              (activity2.id ?? 0).compareTo(activity1.id ?? 0),
        ),
      );
      activities = sorted;
      emit(LoadedActivityState(activities));
    }
  }

  void sortByOldest() {
    if (state is LoadedActivityState) {
      final sorted = List<ActivityModel>.from(
        activities..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0)),
      );
      activities = sorted;
      emit(LoadedActivityState(activities));
    }
  }

  void sortAlphabetically() {
    if (state is LoadedActivityState) {
      final sorted = List<ActivityModel>.from(activities)
        ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
      activities = sorted;
      emit(LoadedActivityState(activities));
    }
  }

  Future<void> refresh() async {
    await getActivities();
  }
}
