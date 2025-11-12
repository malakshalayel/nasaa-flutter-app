import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/constant/app_color.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/coaches/data/models/featured_coach_model.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_state.dart';
import 'package:nasaa/features/coaches/presentation/widgets/coach_card.dart';
import 'package:nasaa/features/coaches/presentation/widgets/filter_bottom_sheet.dart';

class CoachesByActivityScreen extends StatefulWidget {
  const CoachesByActivityScreen({
    super.key,
    required this.activityId,
    required this.activityName,
  });

  final int activityId;
  final String activityName;

  @override
  State<CoachesByActivityScreen> createState() =>
      _CoachesByActivityScreenState();
}

class _CoachesByActivityScreenState extends State<CoachesByActivityScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Store filter parameters
  Map<String, dynamic> _filterParams = {};
  String? _currentSortBy;

  @override
  void initState() {
    super.initState();
    // Initial fetch without filters
    _fetchCoaches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch coaches with current filters and sorting
  void _fetchCoaches() {
    // Start with filter params
    final params = Map<String, dynamic>.from(_filterParams);

    // Always include activity_ids
    params['activity_ids'] = [widget.activityId];

    // Add sorting if selected
    if (_currentSortBy != null && _currentSortBy != 'none') {
      params['sort_by'] = _currentSortBy;
    }

    // Call Cubit to fetch coaches
    context.read<CoachCubit>().getCoachesWithFilters(params);
  }

  // Apply filters from FilterBottomSheet
  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filterParams = filters;
    });
    _fetchCoaches();
  }

  // Apply sorting
  void _applySorting(String sortOption) {
    setState(() {
      _currentSortBy = sortOption;
    });
    _fetchCoaches();
  }

  // Clear all filters and sorting
  void _clearAllFilters() {
    setState(() {
      _filterParams = {};
      _currentSortBy = null;
      _searchController.clear();
    });
    _fetchCoaches();
  }

  // Filter coaches locally by search text
  List _filterCoachesBySearch(
    List<FeaturedCoachModel> coaches,
    String searchText,
  ) {
    if (searchText.isEmpty) return coaches;

    return coaches.where((coach) {
      final name = (coach.name ?? '').toLowerCase();
      final specialty = (coach.status ?? '').toLowerCase();
      final search = searchText.toLowerCase();
      return name.contains(search) || specialty.contains(search);
    }).toList();
  }

  // Get readable filter labels for chips
  String _getFilterLabel(String key, dynamic value) {
    switch (key) {
      case 'rating':
        return 'Rating ≥ $value';
      case 'gender':
        return value == 1 ? 'Male' : 'Female';
      case 'nationality':
        return 'Nationality: $value';
      case 'language_ids':
        return 'Languages: ${(value as List).length}';
      case 'extra_features':
        return 'Features: ${(value as List).join(", ")}';
      case 'min_price':
        return 'Min: \$$value';
      case 'max_price':
        return 'Max: \$$value';
      default:
        return '$key: $value';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = _filterParams.isNotEmpty;
    final hasSorting = _currentSortBy != null && _currentSortBy != 'none';
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.activityName} Coaches',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: scheme.onBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CoachCubit, CoachState>(
        builder: (context, state) {
          if (state is LoadingCoachState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ErrorCoachState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchCoaches,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is LoadedCoachWithFilterState) {
            final allCoaches = state.coachesWithFilters ?? [];

            // Apply local search filter
            final coaches = _filterCoachesBySearch(
              allCoaches,
              _searchController.text,
            );

            return Column(
              children: [
                // Search and Filter Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Search Field
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: "Search by name...",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              setState(() {}); // Rebuild for search
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Filter Button
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: hasActiveFilters
                                  ? AppColor.bronzeColor
                                  : Colors.grey[200],
                            ),
                            child: IconButton(
                              onPressed: () async {
                                final filters = await FilterBottomSheet.show(
                                  context,
                                  currentFilters: _filterParams,
                                );

                                if (filters != null) {
                                  _applyFilters(filters);
                                }
                              },
                              icon: Icon(
                                Icons.filter_list,
                                color: hasActiveFilters
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (hasActiveFilters)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${_filterParams.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(width: 8),

                      // Sort Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: hasSorting
                              ? AppColor.bronzeColor
                              : Colors.grey[200],
                        ),
                        child: IconButton(
                          onPressed: () {
                            _showSortOptions(context);
                          },
                          icon: Icon(
                            Icons.sort,
                            color: hasSorting ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Active Filters Display
                if (hasActiveFilters)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._filterParams.entries.map((entry) {
                          return Chip(
                            label: Text(
                              _getFilterLabel(entry.key, entry.value),
                              style: const TextStyle(fontSize: 12),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              final newFilters = Map<String, dynamic>.from(
                                _filterParams,
                              );
                              newFilters.remove(entry.key);
                              _applyFilters(newFilters);
                            },
                            backgroundColor: AppColor.bronzeColor.withOpacity(
                              0.1,
                            ),
                            deleteIconColor: AppColor.bronzeColor,
                          );
                        }),
                        // Clear all button
                        ActionChip(
                          label: const Text(
                            'Clear All',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: _clearAllFilters,
                          backgroundColor: Colors.red.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),

                // Coaches Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${coaches.length} Coaches found',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (hasSorting)
                        Text(
                          'Sorted: $_currentSortBy',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.bronzeColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Coaches List
                if (coaches.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No coaches found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (hasActiveFilters ||
                              _searchController.text.isNotEmpty)
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          const SizedBox(height: 16),
                          if (hasActiveFilters ||
                              _searchController.text.isNotEmpty)
                            ElevatedButton.icon(
                              onPressed: _clearAllFilters,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Clear Filters'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.bronzeColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: coaches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final coach = coaches[index];
                        return CoachCard(
                          coach: coach,
                          onTapCoachCard: () async {
                            // show loading dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              // Simulate delay or perform lightweight prefetch if needed
                              await Future.delayed(
                                const Duration(milliseconds: 300),
                              );

                              Navigator.of(
                                context,
                              ).pop(); // close the loading dialog

                              // Navigate and let the route create its own cubit
                              Navigator.of(context).pushNamed(
                                RouterName.coachDetails,
                                arguments: coach.id,
                              );
                            } catch (e) {
                              Navigator.of(context).pop();
                              print('Error: $e');
                            }
                          },

                          // onTapCoachCard: () async {
                          //   final cubit = context.read<HomeCubit>();

                          //   // Store the navigator state BEFORE showing dialog
                          //   NavigatorState? navigatorState;

                          //   showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (dialogContext) {
                          //       // Capture the navigator from dialog context
                          //       navigatorState = Navigator.of(dialogContext);
                          //       return const Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     },
                          //   );

                          //   try {
                          //     await cubit.getCoachesDetails(coach.id!);

                          //     // Close dialog using the captured navigator state
                          //     navigatorState?.pop();

                          //     final state = cubit.state;
                          //     if (state is HomeSuccessState &&
                          //         state.coachDetails != null) {
                          //       await navigatorState?.push(
                          //         MaterialPageRoute(
                          //           builder: (_) => BlocProvider.value(
                          //             value: cubit,
                          //             child: CoachDetailsScreen(
                          //               coachDetails: state.coachDetails,
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //       // if (context.mounted) {
                          //       //   _fetchCoaches();
                          //       // }
                          //     }
                          //   } catch (e) {
                          //     navigatorState?.pop();
                          //     log('Error: $e');
                          //   }
                          // },
                          // onTapCoachCard: () async {
                          //   NavigatorState? navigatorState;

                          //   // Show loading dialog
                          //   showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (dialogContext) {
                          //       navigatorState = Navigator.of(dialogContext);
                          //       return const Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     },
                          //   );
                          //   try {
                          //     // Fetch coach details
                          //     await context.read<HomeCubit>().getCoachesDetails(
                          //       coach.id!,
                          //     );
                          //     navigatorState?.pop();
                          //     final currentState = context
                          //         .read<HomeCubit>()
                          //         .state;
                          //     if (context.mounted &&
                          //         currentState is HomeSuccessState &&
                          //         currentState.coachDetails != null) {
                          //       navigatorState?.push(
                          //         MaterialPageRoute(
                          //           builder: (_) => BlocProvider.value(
                          //             value: context.read<HomeCubit>(),
                          //             child: CoachDetailsScreen(
                          //               coachDetails: currentState.coachDetails,
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     }
                          //   } catch (e) {}

                          //   // Close loading dialog

                          //   // Navigate to details screen
                          // },
                        );
                      },
                    ),
                  ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5F1ED),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A2E0F),
                  ),
                ),
                if (_currentSortBy != null)
                  TextButton(
                    onPressed: () {
                      _applySorting('none');
                      Navigator.pop(context);
                    },
                    child: const Text('Clear'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _SortOption(
              icon: Icons.star,
              title: 'Highest Rating',
              value: 'rating_desc',
              isSelected: _currentSortBy == 'rating_desc',
              onTap: () {
                _applySorting('rating_desc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.star_border,
              title: 'Lowest Rating',
              value: 'rating_asc',
              isSelected: _currentSortBy == 'rating_asc',
              onTap: () {
                _applySorting('rating_asc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.attach_money,
              title: 'Price: Low to High',
              value: 'price_asc',
              isSelected: _currentSortBy == 'price_asc',
              onTap: () {
                _applySorting('price_asc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.attach_money,
              title: 'Price: High to Low',
              value: 'price_desc',
              isSelected: _currentSortBy == 'price_desc',
              onTap: () {
                _applySorting('price_desc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.verified,
              title: 'Most Experienced',
              value: 'experience_desc',
              isSelected: _currentSortBy == 'experience_desc',
              onTap: () {
                _applySorting('experience_desc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.fiber_new,
              title: 'Newest First',
              value: 'newest',
              isSelected: _currentSortBy == 'newest',
              onTap: () {
                _applySorting('newest');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.icon,
    required this.title,
    required this.value,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5E34).withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF8B5E34)
                  : const Color(0xFF8B5E34).withOpacity(0.6),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: const Color(0xFF4A2E0F),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF8B5E34),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
