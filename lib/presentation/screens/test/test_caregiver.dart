import 'package:elderwise/di/container.dart';
import 'package:elderwise/domain/entities/caregiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_bloc.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_event.dart';
import 'package:elderwise/presentation/bloc/caregiver/caregiver_state.dart';

class TestCaregiverScreen extends StatefulWidget {
  const TestCaregiverScreen({Key? key}) : super(key: key);

  @override
  _TestCaregiverScreenState createState() => _TestCaregiverScreenState();
}

class _TestCaregiverScreenState extends State<TestCaregiverScreen> {
  final TextEditingController _caregiverIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _profileUrlController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();

  @override
  void dispose() {
    _caregiverIdController.dispose();
    _userIdController.dispose();
    _nameController.dispose();
    _birthdateController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _profileUrlController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  DateTime _parseBirthdate(String input) {
    try {
      return DateTime.parse(input);
    } catch (_) {
      return DateTime.now();
    }
  }

  Caregiver _buildCaregiver() {
    return Caregiver(
      caregiverId: _caregiverIdController.text,
      userId: _userIdController.text,
      name: _nameController.text,
      birthdate: _parseBirthdate(_birthdateController.text),
      gender: _genderController.text,
      phoneNumber: _phoneController.text,
      profileUrl: _profileUrlController.text,
      relationship: _relationshipController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Caregiver')),
      body: BlocProvider<CaregiverBloc>(
        create: (_) => getIt<CaregiverBloc>(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _caregiverIdController,
                decoration: const InputDecoration(labelText: 'Caregiver ID'),
              ),
              TextField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _birthdateController,
                decoration:
                    const InputDecoration(labelText: 'Birthdate (yyyy-MM-dd)'),
              ),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _profileUrlController,
                decoration: const InputDecoration(labelText: 'Profile URL'),
              ),
              TextField(
                controller: _relationshipController,
                decoration: const InputDecoration(labelText: 'Relationship'),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final caregiverId = _caregiverIdController.text;
                      if (caregiverId.isNotEmpty) {
                        context
                            .read<CaregiverBloc>()
                            .add(GetCaregiverEvent(caregiverId));
                      }
                    },
                    child: const Text('Get Caregiver'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final caregiver = _buildCaregiver();
                      context
                          .read<CaregiverBloc>()
                          .add(CreateCaregiverEvent(caregiver));
                    },
                    child: const Text('Create Caregiver'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final caregiverId = _caregiverIdController.text;
                      final caregiver = _buildCaregiver();
                      if (caregiverId.isNotEmpty) {
                        context
                            .read<CaregiverBloc>()
                            .add(UpdateCaregiverEvent(caregiverId, caregiver));
                      }
                    },
                    child: const Text('Update Caregiver'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BlocBuilder<CaregiverBloc, CaregiverState>(
                builder: (context, state) {
                  if (state is CaregiverLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is CaregiverSuccess) {
                    return Text(
                      'Success: ${state.caregiver.toString()}',
                      style: const TextStyle(fontSize: 16),
                    );
                  } else if (state is CaregiverFailure) {
                    return Text(
                      'Error: ${state.error}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    );
                  }
                  return const Text('No action performed yet');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
