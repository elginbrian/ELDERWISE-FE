import 'package:elderwise/di/container.dart';
import 'package:elderwise/data/api/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:get_it/get_it.dart';

class TestUserScreen extends StatefulWidget {
  const TestUserScreen({Key? key}) : super(key: key);

  @override
  _TestUserScreenState createState() => _TestUserScreenState();
}

class _TestUserScreenState extends State<TestUserScreen> {
  final TextEditingController _userIdController = TextEditingController();
  bool _isLoading = true;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _ensureInitialization();
  }

  Future<void> _ensureInitialization() async {
    setState(() {
      _isLoading = true;
      _initError = null;
    });

    try {
      await appConfig.initialize();

      if (!GetIt.instance.isRegistered<UserBloc>()) {
        setupDependencies();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error during initialization: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initError = "Initialization error: $e";
        });
      }
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test User')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _initError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error initializing dependencies',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(_initError!,
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _ensureInitialization,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocProvider<UserBloc>(
      create: (_) {
        try {
          return getIt<UserBloc>();
        } catch (e) {
          print('Error creating UserBloc: $e');
          throw Exception('Could not initialize UserBloc: $e');
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User ID Input',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Actions',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text;
                            if (userId.isNotEmpty) {
                              context
                                  .read<UserBloc>()
                                  .add(GetUserEvent(userId));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a User ID'),
                                ),
                              );
                            }
                          },
                          child: const Text('Get User'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text;
                            if (userId.isNotEmpty) {
                              context
                                  .read<UserBloc>()
                                  .add(GetUserCaregiversEvent(userId));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a User ID'),
                                ),
                              );
                            }
                          },
                          child: const Text('Get User Caregivers'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text;
                            if (userId.isNotEmpty) {
                              context
                                  .read<UserBloc>()
                                  .add(GetUserEldersEvent(userId));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a User ID'),
                                ),
                              );
                            }
                          },
                          child: const Text('Get User Elders'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserSuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Success',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Text(
                              'Response: ${state.response.toJson()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is UserFailure) {
                  return Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Error occurred:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.error,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'No action performed yet. Use the buttons above to perform an action.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
