import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/notification_screen/notification_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final UserMode currentMode;
  final String? elderPhotoUrl;
  final String? caregiverPhotoUrl;

  const ProfileHeader({
    Key? key,
    required this.currentMode,
    this.elderPhotoUrl,
    this.caregiverPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondarySurface,
                spreadRadius: 3,
                blurRadius: 0,
              )
            ],
            image: DecorationImage(
              image: currentMode == UserMode.elder
                  ? (elderPhotoUrl != null
                      ? NetworkImage(elderPhotoUrl!) as ImageProvider
                      : const AssetImage(iconImages + 'google.png'))
                  : (caregiverPhotoUrl != null
                      ? NetworkImage(caregiverPhotoUrl!) as ImageProvider
                      : const AssetImage(iconImages + 'google.png')),
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationScreen()),
            );
          },
          child: Image.asset(
            iconImages + 'notif.png',
            width: 24,
          ),
        ),
      ],
    );
  }
}
