import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  const GenderSelector({super.key});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String selectedGender = 'Male'; // default

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGenderButton('Male', Icons.male),
            const SizedBox(width: 10),
            _buildGenderButton('Female', Icons.female),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final bool isSelected = selectedGender == gender;

    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() => selectedGender = gender);
        },
        icon: Icon(
          icon,
          color: isSelected ? const Color(0xFF7B5B3E) : Colors.grey,
        ),
        label: Text(
          gender,
          style: TextStyle(
            color: isSelected ? const Color(0xFF7B5B3E) : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isSelected ? const Color(0xFF7B5B3E) : Colors.grey.shade300,
            width: 1.4,
          ),
          backgroundColor: isSelected
              ? const Color(0xFFF7F2EE)
              : Colors.grey.shade100, // light fill for selected
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          // maximumSize: Size(95, 37),
        ),
      ),
    );
  }
}
