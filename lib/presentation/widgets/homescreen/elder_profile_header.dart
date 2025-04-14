import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class ElderProfileHeader extends StatelessWidget {
  final String? elderPhotoUrl;
  final Function onNotificationTap;
  final bool showNotifications;

  const ElderProfileHeader({
    Key? key,
    this.elderPhotoUrl,
    required this.onNotificationTap,
    this.showNotifications = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildElderAvatar(),
        if (showNotifications)
          GestureDetector(
            onTap: () => onNotificationTap(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryMain,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_rounded, // Changed to rounded version
                color: AppColors.neutral100,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildElderAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.neutral40,
      backgroundImage: elderPhotoUrl != null && elderPhotoUrl!.isNotEmpty
          ? NetworkImage(elderPhotoUrl!)
          : null,
      child: elderPhotoUrl == null || elderPhotoUrl!.isEmpty
          ? const Icon(
              Icons.person,
              size: 30,
              color: AppColors.neutral60,
            )
          : null,
    );
  }
}
