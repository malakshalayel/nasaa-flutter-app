import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/home/presentation/widgets/activities_section.dart';
import 'package:nasaa/features/home/presentation/widgets/activity_item.dart';
import 'package:nasaa/features/home/presentation/widgets/sort_activities_bottom_sheet.dart';

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
    context.read<HomeCubit>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is HomeSuccessState) {
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
                        context.read<HomeCubit>().sortActivitiesByNewToOld();
                      } else if (value == "Old To New") {
                        context.read<HomeCubit>().sortActivitiesByOldToNew();
                      } else if (value == "Sort A–Z") {
                        context.read<HomeCubit>().sortActivitiesByAZ();
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeSuccessState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- Header Row ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Activities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A2E0F), // brownish title
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
                                context.read<HomeCubit>().getCoachesWithFilters(
                                  {
                                    'activity_ids[]': [
                                      state.activities[index].id!,
                                    ],
                                  },
                                );
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
