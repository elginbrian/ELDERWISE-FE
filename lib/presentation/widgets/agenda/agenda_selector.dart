import 'package:flutter/material.dart';
import 'package:elderwise/presentation/themes/colors.dart';

class AgendaTypeDropdown extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const AgendaTypeDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> agendaOptions = ['Makan', 'Obat', 'Hidrasi', 'Aktivitas'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Agenda',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral80),
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(Icons.category, size: 20, color: AppColors.neutral80),
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.arrow_drop_down, color: AppColors.neutral80),
                      ),
                      dropdownColor: AppColors.secondarySurface,
                      focusColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: AppColors.neutral90,
                      ),
                      hint: const Text(
                        'Pilih jenis agenda',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral80,
                        ),
                      ),
                      itemHeight: 48,
                      onChanged: onChanged,
                      items: agendaOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
