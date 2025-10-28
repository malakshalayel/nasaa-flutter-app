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
        ),
      );
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
