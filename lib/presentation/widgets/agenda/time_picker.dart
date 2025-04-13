import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final String title;
  final String hintText;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onTimeSelected;
  final IconData? icon;
  final String? assetImage;

  const TimePicker({
    super.key,
    required this.title,
    required this.hintText,
    required this.onTimeSelected,
    this.initialTime,
    this.icon,
    this.assetImage,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay? _selectedTime;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  void didUpdateWidget(TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime) {
      setState(() {
        _selectedTime = widget.initialTime;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? widget.initialTime ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryMain,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              dayPeriodColor: AppColors.primarySurface,
              dialBackgroundColor: AppColors.secondarySurface,
            ),
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain,
              onSurface: AppColors.neutral90,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _touched = true;
      });
      widget.onTimeSelected(picked);
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return widget.hintText;
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTime = _selectedTime != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutral80),
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                  child: widget.icon != null
                      ? Icon(widget.icon, size: 20, color: AppColors.neutral80)
                      : widget.assetImage != null
                          ? ImageIcon(
                              AssetImage('assets/icons/${widget.assetImage}'),
                              color: AppColors.neutral80,
                            )
                          : Icon(Icons.access_time,
                              size: 20, color: AppColors.neutral80),
                ),
                Expanded(
                  child: Text(
                    _formatTime(_selectedTime),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color:
                          hasTime ? AppColors.neutral90 : AppColors.neutral80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_touched && _selectedTime == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${widget.title} tidak boleh kosong',
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
