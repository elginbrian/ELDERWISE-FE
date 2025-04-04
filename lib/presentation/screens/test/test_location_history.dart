import 'package:elderwise/di/container.dart';
import 'package:elderwise/data/api/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_bloc.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_event.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_state.dart';
import 'package:get_it/get_it.dart';

class TestLocationHistoryScreen extends StatefulWidget {
  const TestLocationHistoryScreen({Key? key}) : super(key: key);

  @override
  _TestLocationHistoryScreenState createState() =>
      _TestLocationHistoryScreenState();
}

class _TestLocationHistoryScreenState extends State<TestLocationHistoryScreen> {
  final TextEditingController _historyIdController = TextEditingController();
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

      if (!GetIt.instance.isRegistered<LocationHistoryBloc>()) {
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
    _historyIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Location History')),
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
    return BlocProvider<LocationHistoryBloc>(
      create: (_) {
        try {
          return getIt<LocationHistoryBloc>();
        } catch (e) {
          print('Error creating LocationHistoryBloc: $e');
          throw Exception('Could not initialize LocationHistoryBloc: $e');
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
                    Text('Location History ID',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _historyIdController,
                      decoration: const InputDecoration(
                        labelText: 'Location History ID',
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
                            final id = _historyIdController.text;
                            if (id.isNotEmpty) {
                              context
                                  .read<LocationHistoryBloc>()
                                  .add(GetLocationHistoryEvent(id));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a History ID'),
                                ),
                              );
                            }
                          },
                          child: const Text('Get History'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final id = _historyIdController.text;
                            if (id.isNotEmpty) {
                              context
                                  .read<LocationHistoryBloc>()
                                  .add(GetLocationHistoryPointsEvent(id));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a History ID'),
                                ),
                              );
                            }
                          },
                          child: const Text('Get History Points'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<LocationHistoryBloc, LocationHistoryState>(
              builder: (context, state) {
                if (state is LocationHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LocationHistorySuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Location History',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Text(
                              'History: ${state.response.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is LocationHistoryPointsSuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Location History Points',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Text(
                              'History Points: ${state.response.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is LocationHistoryFailure) {
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
