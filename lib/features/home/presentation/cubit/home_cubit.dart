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
  int? selectedCoachId;

  // ✅ Combine both API calls

  Future<void> fetchHomeData() async {
    emit(HomeLoadingState());
    try {
      // Fetch both in parallel
      final results = await Future.wait([
        homeRepo.getCoaches(),
        homeRepo.getActivity(),
        homeRepo.getCoachDetails(1), // Pass a valid coach ID
      ]);

      featuredCoachs = results[0] as List<FeaturedCoachModel>;
      activities = results[1] as List<ActivityModel>;
      coachDetails = results[2] as CoachDetails;

      // Emit once with both data
      emit(
        HomeSuccessState(
          coaches: featuredCoachs,
          activities: activities,
          coachDetails: coachDetails,
          coachesByActivity: coachByActivity,
        ),
      );
    } catch (e) {
      emit(HomeErrorState(e.toString()));
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
      ),
    );
  }

  // getCoachesDetails(int id) async {
  //   selectedCoachId = id;
  //   emit(HomeLoadingState());
  //   try {
  //     coachDetails = await homeRepo.getCoachDetails(id);
  //     final currentState = state;
  //     emit(
  //       HomeSuccessState(
  //         coachesByActivity: (currentState as HomeSuccessState)
  //             .coachesByActivity, // ✅ Preserve
  //         coachDetails: coachDetails, // ✅ Update
  //         activities: currentState.activities, // ✅ Preserve
  //         coaches: currentState.coaches, // ✅ Preserve
  //         // ... add all other fields from currentState
  //       ),
  //     );
  //     // if (state is HomeSuccessState) {
  //     //   emit((state as HomeSuccessState).copyWith(coachDetails: coachDetails));
  //     //   log('Fetched coach details in cubit: ${coachDetails.name}');
  //     // } else {
  //     //   emit(HomeErrorState("Invalid State"));
  //     // }
  //   } catch (e) {
  //     emit(HomeErrorState(e.toString()));
  //   }
  // }

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
      ),
    );
  }

  // Future<void> getCoachsByIndexActivity(List<int> activitiesId) async {
  //   emit(HomeLoadingState());
  //   try {
  //     final response = await homeRepo.getCoachsByIndexActivity(activitiesId);
  //     coachByActivity = response;
  //     emit(
  //       HomeSuccessState(
  //         coaches: coachByActivity,
  //         activities: activities,
  //         coachDetails: coachDetails,
  //         coachesByActivity: coachByActivity,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(HomeErrorState(e.toString()));
  //   }
  // }
}
