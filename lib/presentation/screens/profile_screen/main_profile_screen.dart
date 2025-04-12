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
import 'package:elderwise/presentation/utils/toast_helper.dart';

class MainProfileScreen extends StatefulWidget {
  const MainProfileScreen({super.key});

  @override
  State<MainProfileScreen> createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  bool _isLoading = true;
  bool _dataFetched = false;
  String? _userId;
  dynamic _elderData;
  String? _elderPhotoUrl;
  dynamic _caregiverData;
  String? _caregiverPhotoUrl;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchData();
    });
  }

  void _prefetchData() {
    context.read<AuthBloc>().add(GetCurrentUserEvent());
  }

  void _fetchUserData(String userId) {
    if (_dataFetched) return;

    setState(() {
      _userId = userId;
    });

    if (_userId != null && _userId!.isNotEmpty) {
      context.read<UserBloc>().add(GetUserEldersEvent(_userId!));
      context.read<UserBloc>().add(GetUserCaregiversEvent(_userId!));

      _dataFetched = true;
    }
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];
    setState(() {
      _elderData = elder;

      if (elder['photo_url'] != null) {
        _elderPhotoUrl = elder['photo_url'];
      }
    });
  }

  void _populateCaregiverData(dynamic caregiverData) {
    if (caregiverData == null || caregiverData.isEmpty) return;

    final caregiver = caregiverData[0];
    setState(() {
      _caregiverData = caregiver;

      if (caregiver['profile_url'] != null) {
        _caregiverPhotoUrl = caregiver['profile_url'];
      } else if (caregiver['photo_url'] != null) {
        _caregiverPhotoUrl = caregiver['photo_url'];
      }
    });
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        },
      ),
    ).then((_) {
      if (_userId != null) {
        setState(() {
          _dataFetched = false;
        });
        _fetchUserData(_userId!);
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
              final userId = state.user.user.userId;
              _fetchUserData(userId);
            } else if (state is AuthFailure) {
              setState(() => _isLoading = false);
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isLoading = false);

              if (state.response.data != null && state.response.data is Map) {
                if (state.response.data.containsKey('elders')) {
                  _populateElderData(state.response.data['elders']);
                }

                if (state.response.data.containsKey('caregivers')) {
                  _populateCaregiverData(state.response.data['caregivers']);
                }
              }
            } else if (state is UserFailure) {
              setState(() => _isLoading = false);
              ToastHelper.showErrorToast(context,
                  ToastHelper.getUserFriendlyErrorMessage(state.error));
            }
          },
        ),
      ],
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isLoading
              ? _buildLoadingScreen()
              : Container(
                  key: const ValueKey('main_content'),
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
                            _buildProfileImages(),
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
                                    onTap: _navigateToProfileScreen,
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
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      key: const ValueKey('loading_screen'),
      color: AppColors.neutral20,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMain),
            ),
            const SizedBox(height: 24),
            Text(
              "Memuat profil Anda...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImages() {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 5),
          image: DecorationImage(
            image: _elderPhotoUrl != null && _elderPhotoUrl!.isNotEmpty
                ? NetworkImage(_elderPhotoUrl!) as ImageProvider
                : const AssetImage(
                    'lib/presentation/screens/assets/images/banner.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        top: -10,
        right: -20,
        child: CircleAvatar(
          radius: 32.5,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 29,
            backgroundImage:
                _caregiverPhotoUrl != null && _caregiverPhotoUrl!.isNotEmpty
                    ? NetworkImage(_caregiverPhotoUrl!) as ImageProvider
                    : const AssetImage(
                        'lib/presentation/screens/assets/images/onboard.png'),
          ),
        ),
      )
    ]);
  }
}
