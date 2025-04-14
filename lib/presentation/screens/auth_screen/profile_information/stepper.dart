import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/caregiver_profile.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/elder_profile.dart';
import 'package:elderwise/presentation/screens/auth_screen/profile_information/photo_profile.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int currentStep = 0;
  String userId = '';
  bool isLoading = true;

  final List<String> stepTitles = [
    "Profile Elder",
    "Profile Caregiver",
    "Profile Photo"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(GetCurrentUserEvent());
    });
  }

  void nextStep() {
    if (currentStep < 2) {
      setState(() => currentStep += 1);
    } else {
      context.go('/mode');
    }
  }

  void skipStep() {
    if (currentStep < 2) {
      setState(() => currentStep += 1);
    } else {
      context.go('/mode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is CurrentUserSuccess) {
          setState(() {
            userId = state.user.user.userId;
            isLoading = false;
          });
        } else if (state is AuthFailure) {
          debugPrint('Auth Error: ${state.error}');
          setState(() {
            isLoading = false;
          });
          context.go('/login');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return WillPopScope(
          onWillPop: () async {
            if (currentStep > 0) {
              setState(() => currentStep -= 1);
              return false;
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColors.secondarySurface,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: const Icon(Icons.arrow_back_ios,
                            color: AppColors.neutral90),
                        onPressed: () {
                          if (currentStep > 0) {
                            setState(() => currentStep -= 1);
                          } else {
                            context.go('/login');
                          }
                        },
                      ),
                    ),
                    title: Text(
                      stepTitles[currentStep],
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          if (index % 2 == 0) {
                            return _buildStepIndicator(index ~/ 2);
                          } else {
                            return _buildConnector(
                                (index - 1) ~/ 2 < currentStep);
                          }
                        }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: IndexedStack(
                          index: currentStep,
                          children: [
                            ElderProfile(
                              onNext: nextStep,
                              onSkip: skipStep,
                              isFinalStep: false,
                              userId: userId,
                            ),
                            CaregiverProfile(
                              onNext: nextStep,
                              onSkip: skipStep,
                              isFinalStep: false,
                              userId: userId,
                            ),
                            PhotoProfile(
                              onNext: nextStep,
                              onSkip: skipStep,
                              isFinalStep: true,
                              userId: userId,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepIndicator(int step) {
    bool isCompleted = step < currentStep;
    bool isCurrent = step == currentStep;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent
            ? AppColors.primaryMain
            : Colors.grey.shade300,
        border: Border.all(
          color: isCompleted || isCurrent
              ? AppColors.primaryMain
              : Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                "${step + 1}",
                style: TextStyle(
                  color: isCurrent ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? AppColors.primaryMain : Colors.grey.shade300,
    );
  }
}
