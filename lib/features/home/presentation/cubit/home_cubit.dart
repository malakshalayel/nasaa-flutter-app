import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/features/home/data/models/activity_model.dart';
import 'package:nasaa/features/home/data/models/coch_details_response.dart';
import 'package:nasaa/features/home/data/models/featured_coach_model.dart';
import 'package:nasaa/features/home/data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeRepo homeRepo;
  HomeCubit(this.homeRepo) : super(HomeInitial());

  List<FeaturedCoachModel> featuredCoachs = [];
  List<ActivityModel> activities = [];
  CoachDetails coachDetails = CoachDetails();
  List<FeaturedCoachModel> coachByActivity = [];
  List<FeaturedCoachModel> favoriteCoaches = [];
  int? selectedCoachId;

  // ✅ Combine both API calls
  Future<void> fetchHomeData() async {
    if (isClosed) return; // ✅ Prevent emit after close
    emit(HomeLoadingState());
    try {
      final results = await Future.wait([
        homeRepo.getCoaches(),
        homeRepo.getActivity(),
        homeRepo.getCoachDetails(1),
      ]);

      if (isClosed) return; // ✅ Check again after async call

      featuredCoachs = results[0] as List<FeaturedCoachModel>;
      activities = results[1] as List<ActivityModel>;
      coachDetails = results[2] as CoachDetails;

      emit(
        HomeSuccessState(
          coaches: featuredCoachs,
          activities: activities,
          coachDetails: coachDetails,
          coachesByActivity: coachByActivity,
          favoriteCoches: favoriteCoaches,
        ),
      );
    } catch (e, s) {
      log('❌ fetchHomeData error: $e\n$s');
      if (!isClosed) emit(HomeErrorState(e.toString()));
    }
  }

  sortActivitiesByNewToOld() {
    activities.sort((a, b) => b.id!.compareTo(a.id!));
    emit(
      HomeSuccessState(
        coaches: featuredCoachs,
        activities: activities,
        coachDetails: coachDetails,
        coachesByActivity: coachByActivity,
        favoriteCoches: favoriteCoaches,
      ),
    );
  }

  sortActivitiesByOldToNew() {
    activities.sort((a, b) => a.id!.compareTo(b.id!));
    emit(
      HomeSuccessState(
        coaches: featuredCoachs,
        activities: activities,
        coachDetails: coachDetails,
        coachesByActivity: coachByActivity,
        favoriteCoches: favoriteCoaches,
      ),
    );
  }

  sortActivitiesByAZ() {
    activities.sort((a, b) => a.name!.compareTo(b.name!));
    emit(
      HomeSuccessState(
        coaches: featuredCoachs,
        activities: activities,
        coachDetails: coachDetails,
        coachesByActivity: coachByActivity,
        favoriteCoches: favoriteCoaches,
      ),
    );
  }

  getCoachesDetails(int id) async {
    selectedCoachId = id;
    final currentState = state; // ✅ read first

    // emit(HomeLoadingState());
    try {
      coachDetails = await homeRepo.getCoachDetails(id);

      if (currentState is HomeSuccessState) {
        emit(
          HomeSuccessState(
            coachesByActivity: currentState.coachesByActivity,
            coachDetails: coachDetails,
            activities: currentState.activities,
            coaches: currentState.coaches,
            favoriteCoches: currentState.favoriteCoches,
          ),
        );
      } else {
        // fallback if it wasn't success before
        emit(
          HomeSuccessState(
            coachesByActivity: [],
            coachDetails: coachDetails,
            activities: [],
            coaches: [],
            favoriteCoches: [],
          ),
        );
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  Future<void> getCoachesWithFilters(Map<String, dynamic> filterParams) async {
    emit(HomeLoadingState()); // Show loading indicator

    log('🎯 Cubit: Fetching coaches with filters: $filterParams');

    final coaches = await homeRepo.getCoachesWithFilters(filterParams);

    emit(
      HomeSuccessState(
        coachesByActivity: coaches,
        coaches: featuredCoachs,
        activities: activities,
        coachDetails: coachDetails,
        favoriteCoches: favoriteCoaches,
      ),
    );
  }

  // Future<void> addOrRemoveFromFavorite(int coachId) async {
  //   if (state is! HomeSuccessState) return;
  //   try {
  //     log("here");
  //     favoriteCoaches = await homeRepo.addOrRemoveFromFavorite(coachId);
  //     if (state is HomeSuccessState) {
  //       final currentState = state as HomeSuccessState;
  //       emit(currentState.copyWith(favoriteCoches: favoriteCoaches));
  //     }

  //     log("success");
  //   } catch (e) {
  //     emit(HomeErrorState(e.toString()));
  //   }
  // }

  Future<void> addOrRemoveFromFavorite(FeaturedCoachModel coach) async {
    if (state is! HomeSuccessState) return;

    try {
      log("Toggling favorite for coach: ${coach.id}");
      favoriteCoaches = await homeRepo.addOrRemoveFromFavorite(
        coach.id!,
        coach, // Pass the coach object
      );

      if (state is HomeSuccessState) {
        final currentState = state as HomeSuccessState;
        emit(currentState.copyWith(favoriteCoches: favoriteCoaches));
        log("Favorites updated - Total: ${favoriteCoaches?.length}");
      }
    } catch (e) {
      log("Error: $e");
      emit(HomeErrorState(e.toString()));
    }
  }

  // Add this method to fetch favorites
  void getFavoriteCoaches() {
    if (state is HomeSuccessState) {
      final favorites = homeRepo.getFavoriteCoaches();
      final currentState = state as HomeSuccessState;
      emit(currentState.copyWith(favoriteCoches: favorites));
    }
  }
}
