import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String placeholder;
  final bool readOnly;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onDateSelected,
    this.placeholder = 'Pilih tanggal lahir',
    this.readOnly = false,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  bool _touched = false;

  Future<void> _selectDate(BuildContext context) async {
    if (widget.readOnly) return;

    setState(() {
      _touched = true;
    });

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain,
              onPrimary: Colors.white,
              onSurface: AppColors.neutral90,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryMain,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.selectedDate) {
      widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutral80),
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Icon(Icons.calendar_today,
                      size: 20, color: AppColors.neutral80),
                ),
                Expanded(
                  child: Text(
                    widget.controller.text.isNotEmpty
                        ? widget.controller.text
                        : widget.placeholder,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: widget.controller.text.isNotEmpty
                          ? AppColors.neutral90
                          : AppColors.neutral80,
                    ),
                  ),
                ),
                if (!widget.readOnly)
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.arrow_drop_down,
                        size: 20, color: AppColors.neutral80),
                  ),
              ],
            ),
          ),
        ),
        if (_touched && widget.controller.text.isEmpty && !widget.readOnly)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tanggal lahir tidak boleh kosong',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
