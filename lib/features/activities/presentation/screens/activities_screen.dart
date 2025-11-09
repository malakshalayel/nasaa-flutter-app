import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_state.dart';
import 'package:nasaa/features/activities/presentation/widgets/activity_item.dart';
import 'package:nasaa/features/activities/presentation/widgets/sort_activities_bottom_sheet.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_list/coach_list_cubit.dart';
import 'package:nasaa/generated/l10n.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String _selectedOption = "New To Old";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // context.read<HomeCubit>().fetchHomeData();
    context.read<ActivityCubit>().getActivities();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocListener<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is ErrorActivityState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is LoadedActivityState) {
          print("Fetched activities: ${state.activities.length}");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => SortBottomSheet(
                    selectedOption: _selectedOption,
                    onChanged: (value) {
                      print("Selected sort: $value");
                      setState(() {
                        _selectedOption = value;
                      });
                      if (value == "New To Old") {
                        context.read<ActivityCubit>().sortByNewst();
                      } else if (value == "Old To New") {
                        context.read<ActivityCubit>().sortByOldest();
                      } else if (value == "Sort A–Z") {
                        context.read<ActivityCubit>().sortAlphabetically();
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is LoadingActivityState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedActivityState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- Header Row ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).activities,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: scheme.onBackground, // brownish title
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// --- Horizontal Activities Scroll ---
                  Column(
                    children: List.generate(
                      3,
                      (index) => SizedBox(
                        height: 120,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.activities.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final activityName = state.activities[index].name!;
                            final activityId = state.activities[index].id!;
                            return ActivityItem(
                              activity: state.activities[index],
                              onTap: () {
                                context
                                    .read<CoachCubit>()
                                    .getCoachesWithFilters({
                                      'activity_ids[]': [
                                        state.activities[index].id!,
                                      ],
                                    });
                                Navigator.pushNamed(
                                  context,
                                  RouterName.coachesByActivityScreen,
                                  arguments: {
                                    'activityId': activityId,
                                    'activityName': activityName,
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Text("faild");
          },
        ),
      ),
    );
  }
}
