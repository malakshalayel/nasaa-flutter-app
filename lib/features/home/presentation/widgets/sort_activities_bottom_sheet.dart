import 'package:flutter/material.dart';

class SortBottomSheet extends StatefulWidget {
  final String? selectedOption;
  final ValueChanged<String> onChanged;

  const SortBottomSheet({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    final options = ["New To Old", "Old To New", "Sort A–Z"];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFEFBF7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sort",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A2E0F),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF4A2E0F)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Color(0xFFE8E3DC)),

          // Options List
          ...options.map(
            (option) => RadioListTile<String>(
              activeColor: const Color(0xFF4A2E0F),
              contentPadding: EdgeInsets.zero,
              title: Text(
                option,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A2E0F),
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: option,

              groupValue: _selected,
              onChanged: (value) {
                setState(() => _selected = value);
                widget.onChanged(value!);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
