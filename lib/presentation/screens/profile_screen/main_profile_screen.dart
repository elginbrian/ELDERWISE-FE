import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../themes/colors.dart';
import 'profile_screen.dart';

class MainProfileScreen extends StatefulWidget {
  const MainProfileScreen({super.key});

  @override
  State<MainProfileScreen> createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  bool _isLoading = true;
  String? _userId;
  dynamic _elderData;
  String? _elderPhotoUrl;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call GetCurrentUserEvent from AuthBloc
      context.read<AuthBloc>().add(GetCurrentUserEvent());
    });
  }

  void _fetchUserData(String userId) {
    setState(() {
      _userId = userId;
    });

    // Fetch elder data
    if (_userId != null && _userId!.isNotEmpty) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId!));
    }
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];
    setState(() {
      _elderData = elder;

      // Get photo URL
      if (elder['photo_url'] != null) {
        _elderPhotoUrl = elder['photo_url'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CurrentUserSuccess) {
              // Extract user ID from CurrentUserSuccess state
              final userId = state.user.user.userId;
              _fetchUserData(userId);
            } else if (state is AuthFailure) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to fetch user data: ${state.error}')),
              );
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isLoading = false);

              // Check what type of response we received
              if (state.response.data != null && state.response.data is Map) {
                // Check if it's elder data
                if (state.response.data.containsKey('elders')) {
                  _populateElderData(state.response.data['elders']);
                }
              }
            } else if (state is UserFailure) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Failed to fetch profile data: ${state.error}')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
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
                                border:
                                    Border.all(color: Colors.white, width: 5),
                                image: DecorationImage(
                                  image: _elderPhotoUrl != null &&
                                          _elderPhotoUrl!.isNotEmpty
                                      ? NetworkImage(_elderPhotoUrl!)
                                          as ImageProvider
                                      : AssetImage(
                                          'lib/presentation/screens/assets/images/banner.png'),
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
                            children: [
                              Text(
                                _elderData != null
                                    ? _elderData['name'] ?? "Elder"
                                    : "Elder",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: AppColors.neutral100,
                                ),
                              ),
                              const Text(
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
                                        builder: (context) =>
                                            const ProfileScreen(),
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
      ),
    );
  }
}
