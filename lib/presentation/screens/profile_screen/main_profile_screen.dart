import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import 'profile_screen.dart'; // pastikan ini ada

class MainProfileScreen extends StatefulWidget {
  const MainProfileScreen({super.key});

  @override
  State<MainProfileScreen> createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/presentation/screens/assets/images/bg_floral.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.15),
              child: Column(
                children: [
                  Stack(clipBehavior: Clip.none, children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        image: const DecorationImage(
                          image: AssetImage(
                            'lib/presentation/screens/assets/images/banner.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: -10,
                      right: -20,
                      child: CircleAvatar(
                        radius: 32.5,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundImage: AssetImage(
                            'lib/presentation/screens/assets/images/onboard.png',
                          ),
                        ),
                      ),
                    )
                  ]),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Mbah Eglin",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral100,
                        ),
                      ),
                      Text(
                        "Elder",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral90,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.neutral20,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        MainButton(
                          buttonText: "Profil Lengkap",
                          color: AppColors.secondarySurface,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          textAlign: TextAlign.left,
                          iconAsset: 'username.png',
                        ),
                        const SizedBox(height: 16),
                        MainButton(
                          buttonText: "Riwayat",
                          color: AppColors.secondarySurface,
                          onTap: () {},
                          textAlign: TextAlign.left,
                          iconAsset: 'username.png',
                        ),
                        const SizedBox(height: 24),
                        MainButton(
                          buttonText: "Aktifkan Mode Elder?",
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Keluar",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: AppColors.neutral90,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
