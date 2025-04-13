import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class ElderProfileHeader extends StatelessWidget {
  final String? elderPhotoUrl;
  final VoidCallback onNotificationTap;

  const ElderProfileHeader({
    Key? key,
    this.elderPhotoUrl,
    required this.onNotificationTap,
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
              image: elderPhotoUrl != null && elderPhotoUrl!.isNotEmpty
                  ? NetworkImage(elderPhotoUrl!) as ImageProvider
                  : const AssetImage(
                      'lib/presentation/screens/assets/images/elder_placeholder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap,
          child: Image.asset(
            iconImages + 'notif.png',
            width: 24,
          ),
        ),
      ],
    );
  }
}
