import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class RadiusSliderWidget extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String description;
  final String minLabel;
  final String maxLabel;

  const RadiusSliderWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.description,
    this.min = 0.1,
    this.max = 15.0,
    this.divisions = 150,
    this.minLabel = "0.5 KM",
    this.maxLabel = "15 KM",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Container(
              width: 60,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.neutral90),
              ),
              child: Center(
                child: Text(
                  "${value.toStringAsFixed(1)} KM",
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            description,
            textAlign: TextAlign.justify,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            activeTrackColor: AppColors.primaryMain,
            inactiveTrackColor: AppColors.neutral20,
            thumbColor: AppColors.primaryMain,
          ),
          child: Slider(
            min: min,
            max: max,
            divisions: divisions,
            value: value,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minLabel),
              Text(maxLabel),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
