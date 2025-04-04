import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeTest extends StatelessWidget {
  const HomeTest({Key? key}) : super(key: key);

  Widget _buildNavButton(BuildContext context, String label, String route) {
    return ElevatedButton(
      onPressed: () => context.go(route),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elderwise Test Home')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavButton(context, 'Test Agenda', '/testAgenda'),
              _buildNavButton(context, 'Test Area', '/testArea'),
              _buildNavButton(context, 'Test Auth', '/testAuth'),
              _buildNavButton(context, 'Test Caregiver', '/testCaregiver'),
              _buildNavButton(context, 'Test Elder', '/testElder'),
              _buildNavButton(
                  context, 'Test Emergency Alert', '/testEmergencyAlert'),
              _buildNavButton(context, 'Test User', '/testUser'),
              _buildNavButton(
                  context, 'Test Location History', '/testLocationHistory'),
            ],
          ),
        ),
      ),
    );
  }
}
