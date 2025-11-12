import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_state.dart';
import 'package:nasaa/features/activities/presentation/widgets/activity_item.dart';
import 'package:nasaa/features/activities/presentation/widgets/sort_activities_bottom_sheet.dart';
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
    super.initState();
    // ✅ Only fetch if not already loaded
    final activityCubit = context.read<ActivityCubit>();
    if (activityCubit.state is! LoadedActivityState) {
      activityCubit.getActivities();
    }
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
          title: Text(S.of(context).activities),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (sheetContext) => SortBottomSheet(
                    selectedOption: _selectedOption,
                    onChanged: (value) {
                      print("Selected sort: $value");
                      setState(() {
                        _selectedOption = value;
                      });
                      if (value == "New To Old") {
                        context.read<ActivityCubit>().sortByNewest();
                      } else if (value == "Old To New") {
                        context.read<ActivityCubit>().sortByOldest();
                      } else if (value == "Sort A—Z") {
                        context.read<ActivityCubit>().sortAlphabetically();
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<ActivityCubit>().refresh(),
          child: BlocBuilder<ActivityCubit, ActivityState>(
            builder: (context, state) {
              if (state is LoadingActivityState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedActivityState) {
                if (state.activities.isEmpty) {
                  return Center(
                    child: Text(
                      'No activities found',
                      style: TextStyle(
                        fontSize: 16,
                        color: scheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    /// --- Header ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        S.of(context).activities,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: scheme.onBackground,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: state.activities.length,
                        itemBuilder: (context, index) {
                          final activity = state.activities[index];
                          return ActivityItem(
                            activity: activity,
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                RouterName.coachesByActivityScreen,
                                arguments: {
                                  'activityId': activity.id,
                                  'activityName': activity.name,
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is ErrorActivityState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ActivityCubit>().getActivities(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text("No data available"));
            },
          ),
        ),
      ),
    );
  }
}
