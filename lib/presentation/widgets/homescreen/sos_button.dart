import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SosButton extends StatefulWidget {
  final VoidCallback onTap;

  const SosButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isCountdownActive = false;
  int _countdown = 10;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _cancelCountdown();
    super.dispose();
  }

  void _vibrate() {
    HapticFeedback.heavyImpact(); // Vibrate with heavy impact effect
  }

  void _startCountdown() {
    setState(() {
      _isCountdownActive = true;
      _countdown = 10;
    });

    _vibrate(); // Initial vibration when countdown starts

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        _cancelCountdown();
        widget.onTap(); // Actually send the SOS alert
      } else {
        setState(() {
          _countdown--;
          _vibrate(); // Vibrate on each tick
        });
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    setState(() {
      _isCountdownActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCountdownActive) {
      // Show countdown circle instead of SOS button with animation
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: _cancelCountdown,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Third outer circle with white background - larger and no shadow
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 252, 217, 1),
                ),
              ),
              // Middle circle - larger
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryHover.withOpacity(0.3),
                ),
              ),
              // Inner circle with countdown - larger and no shadow
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryMain,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _countdown.toString(),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text(
                        "Tap to cancel",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Show regular SOS button
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: _startCountdown,
          child: Image.asset(
            iconImages + 'sos.png',
            width: 256,
          ),
        ),
      );
    }
  }
}
