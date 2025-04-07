import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class ProfileToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProfileToggle({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.size(
      current: value,
      values: const [false, true],
      iconOpacity: .7,
      indicatorSize: const Size.fromHeight(100),
      customIconBuilder: (context, local, global) => Text(
        local.value ? 'Elder' : 'Caregiver',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: AppColors.neutral90,
        ),
      ),
      borderWidth: 5,
      iconAnimationType: AnimationType.onHover,
      style: ToggleStyle(
        backgroundColor: AppColors.secondarySurface,
        indicatorColor: AppColors.primaryMain,
        borderColor: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(32),
      ),
      selectedIconScale: 1,
      onChanged: onChanged,
    );
  }
}
