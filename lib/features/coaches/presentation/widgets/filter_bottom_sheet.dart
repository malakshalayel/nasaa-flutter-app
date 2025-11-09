import 'package:flutter/material.dart';
import 'package:nasaa/core/constant/app_color.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;

  const FilterBottomSheet({super.key, this.currentFilters = const {}});

  /// Show the filter bottom sheet and return selected filters
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    Map<String, dynamic>? currentFilters,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FilterBottomSheet(currentFilters: currentFilters ?? {}),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Controllers for text inputs
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  // Filter values
  double? _selectedRating;
  int? _selectedGender; // 1 = Male, 2 = Female
  int? _selectedNationality;
  List<int> _selectedLanguages = [];
  List<String> _selectedFeatures = [];
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  void _loadCurrentFilters() {
    _selectedRating = widget.currentFilters['rating']?.toDouble();
    _selectedGender = widget.currentFilters['gender'];
    _selectedNationality = widget.currentFilters['nationality'];
    _selectedLanguages = List<int>.from(
      widget.currentFilters['language_ids'] ?? [],
    );
    _selectedFeatures = List<String>.from(
      widget.currentFilters['extra_features'] ?? [],
    );
    _minPrice = widget.currentFilters['min_price']?.toDouble();
    _maxPrice = widget.currentFilters['max_price']?.toDouble();

    if (_minPrice != null) {
      _minPriceController.text = _minPrice!.toStringAsFixed(0);
    }
    if (_maxPrice != null) {
      _maxPriceController.text = _maxPrice!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};

    if (_selectedRating != null) {
      filters['rating'] = _selectedRating;
    }
    if (_selectedGender != null) {
      filters['gender'] = _selectedGender;
    }
    if (_selectedNationality != null) {
      filters['nationality'] = _selectedNationality;
    }
    if (_selectedLanguages.isNotEmpty) {
      filters['language_ids'] = _selectedLanguages;
    }
    if (_selectedFeatures.isNotEmpty) {
      filters['extra_features'] = _selectedFeatures;
    }
    if (_minPrice != null) {
      filters['min_price'] = _minPrice!.toInt();
    }
    if (_maxPrice != null) {
      filters['max_price'] = _maxPrice!.toInt();
    }

    Navigator.pop(context, filters);
  }

  void _clearFilters() {
    setState(() {
      _selectedRating = null;
      _selectedGender = null;
      _selectedNationality = null;
      _selectedLanguages = [];
      _selectedFeatures = [];
      _minPrice = null;
      _maxPrice = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFilters =
        _selectedRating != null ||
        _selectedGender != null ||
        _selectedNationality != null ||
        _selectedLanguages.isNotEmpty ||
        _selectedFeatures.isNotEmpty ||
        _minPrice != null ||
        _maxPrice != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title and Clear Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2E0F),
                          ),
                        ),
                        Row(
                          children: [
                            if (hasFilters)
                              TextButton(
                                onPressed: _clearFilters,
                                child: Text(
                                  'Clear All',
                                  style: TextStyle(color: AppColor.bronzeColor),
                                ),
                              ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Rating Filter
                    _FilterSection(
                      title: 'Minimum Rating',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            value: _selectedRating ?? 0,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            label: _selectedRating != null
                                ? _selectedRating!.toStringAsFixed(1)
                                : 'Any',
                            activeColor: AppColor.bronzeColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedRating = value == 0 ? null : value;
                              });
                            },
                          ),

                          Center(
                            child: Text(
                              _selectedRating != null
                                  ? '${_selectedRating!.toStringAsFixed(1)} stars and above'
                                  : 'Any rating',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Gender Filter
                    _FilterSection(
                      title: 'Gender',
                      child: Row(
                        children: [
                          Expanded(
                            child: _ChoiceChip(
                              label: 'Male',
                              icon: Icons.male,
                              selected: _selectedGender == 1,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedGender = selected ? 1 : null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ChoiceChip(
                              label: 'Female',
                              icon: Icons.female,
                              selected: _selectedGender == 2,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedGender = selected ? 2 : null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Price Range Filter
                    _FilterSection(
                      title: 'Price Range (\$)',
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min',
                                prefixText: '\$ ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) {
                                _minPrice = double.tryParse(value);
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'to',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _maxPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Max',
                                prefixText: '\$ ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) {
                                _maxPrice = double.tryParse(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Extra Features Filter
                    _FilterSection(
                      title: 'Extra Features',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FeatureChip(
                            label: 'Family Friendly',
                            icon: Icons.family_restroom,
                            selected: _selectedFeatures.contains('family'),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFeatures.add('family');
                                } else {
                                  _selectedFeatures.remove('family');
                                }
                              });
                            },
                          ),
                          _FeatureChip(
                            label: 'Online Training',
                            icon: Icons.videocam,
                            selected: _selectedFeatures.contains('online'),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFeatures.add('online');
                                } else {
                                  _selectedFeatures.remove('online');
                                }
                              });
                            },
                          ),
                          _FeatureChip(
                            label: 'Group Sessions',
                            icon: Icons.groups,
                            selected: _selectedFeatures.contains('group'),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFeatures.add('group');
                                } else {
                                  _selectedFeatures.remove('group');
                                }
                              });
                            },
                          ),
                          _FeatureChip(
                            label: 'Private Sessions',
                            icon: Icons.person,
                            selected: _selectedFeatures.contains('private'),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFeatures.add('private');
                                } else {
                                  _selectedFeatures.remove('private');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for apply button
                  ],
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.bronzeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        hasFilters ? 'Apply Filters' : 'Show All Coaches',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Helper widget for filter sections
class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A2E0F),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

// Choice chip for gender selection
class _ChoiceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _ChoiceChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(!selected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColor.bronzeColor.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColor.bronzeColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? AppColor.bronzeColor : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColor.bronzeColor : Colors.grey[700],
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Feature chip for extra features
class _FeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FeatureChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: selected ? Colors.white : AppColor.bronzeColor,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: AppColor.bronzeColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF4A2E0F),
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }
}
