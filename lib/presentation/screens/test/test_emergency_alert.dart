import 'package:elderwise/di/container.dart';
import 'package:elderwise/data/api/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/data/api/requests/emergency_alert_request.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_bloc.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_event.dart';
import 'package:elderwise/presentation/bloc/emergency_alert/emergency_alert_state.dart';
import 'package:get_it/get_it.dart';

class TestEmergencyAlertScreen extends StatefulWidget {
  const TestEmergencyAlertScreen({Key? key}) : super(key: key);

  @override
  _TestEmergencyAlertScreenState createState() =>
      _TestEmergencyAlertScreenState();
}

class _TestEmergencyAlertScreenState extends State<TestEmergencyAlertScreen> {
  final TextEditingController _alertIdController = TextEditingController();
  final TextEditingController _elderIdController = TextEditingController();
  final TextEditingController _caregiverIdController = TextEditingController();
  final TextEditingController _elderLatController = TextEditingController();
  final TextEditingController _elderLongController = TextEditingController();
  bool _isDismissed = false;
  DateTime _selectedDateTime = DateTime.now();
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

      if (!GetIt.instance.isRegistered<EmergencyAlertBloc>()) {
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
    _alertIdController.dispose();
    _elderIdController.dispose();
    _caregiverIdController.dispose();
    _elderLatController.dispose();
    _elderLongController.dispose();
    super.dispose();
  }

  // Method to populate form fields with fetched data
  void _populateFormWithAlertData(dynamic alertData) {
    if (alertData == null) return;

    setState(() {
      _alertIdController.text = alertData.id?.toString() ?? '';
      _elderIdController.text = alertData.elderId?.toString() ?? '';
      _caregiverIdController.text = alertData.caregiverId?.toString() ?? '';
      _elderLatController.text = alertData.elderLat?.toString() ?? '';
      _elderLongController.text = alertData.elderLong?.toString() ?? '';
      if (alertData.datetime != null) {
        _selectedDateTime = alertData.datetime;
      }
      _isDismissed = alertData.isDismissed ?? false;
    });
  }

  EmergencyAlertRequestDTO _buildAlertRequest() {
    return EmergencyAlertRequestDTO(
      elderId: _elderIdController.text,
      caregiverId: _caregiverIdController.text,
      datetime: _selectedDateTime,
      elderLat: double.tryParse(_elderLatController.text) ?? 0.0,
      elderLong: double.tryParse(_elderLongController.text) ?? 0.0,
      isDismissed: _isDismissed,
    );
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Emergency Alert')),
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
    return BlocProvider<EmergencyAlertBloc>(
      create: (_) {
        try {
          return getIt<EmergencyAlertBloc>();
        } catch (e) {
          print('Error creating EmergencyAlertBloc: $e');
          throw Exception('Could not initialize EmergencyAlertBloc: $e');
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
                    Text('Alert Details',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _alertIdController,
                      decoration: const InputDecoration(
                        labelText: 'Alert ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _elderIdController,
                      decoration: const InputDecoration(
                        labelText: 'Elder ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _caregiverIdController,
                      decoration: const InputDecoration(
                        labelText: 'Caregiver ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _elderLatController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Elder Latitude',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _elderLongController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Elder Longitude',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Datetime:'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${_selectedDateTime.toLocal()}'.split('.')[0],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _selectDateTime,
                          child: const Text('Select Date & Time'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Is Dismissed:'),
                        Switch(
                          value: _isDismissed,
                          onChanged: (value) {
                            setState(() {
                              _isDismissed = value;
                            });
                          },
                        ),
                      ],
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
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final alertId = _alertIdController.text;
                            if (alertId.isNotEmpty) {
                              context
                                  .read<EmergencyAlertBloc>()
                                  .add(GetEmergencyAlertEvent(alertId));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter an Alert ID'),
                                ),
                              );
                            }
                          },
                          child: const Text('Get Alert'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_elderIdController.text.isEmpty ||
                                _caregiverIdController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please enter Elder ID and Caregiver ID'),
                                ),
                              );
                              return;
                            }
                            context.read<EmergencyAlertBloc>().add(
                                CreateEmergencyAlertEvent(
                                    _buildAlertRequest()));
                          },
                          child: const Text('Create Alert'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final alertId = _alertIdController.text;
                            if (alertId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter an Alert ID'),
                                ),
                              );
                              return;
                            }
                            context.read<EmergencyAlertBloc>().add(
                                UpdateEmergencyAlertEvent(
                                    alertId, _buildAlertRequest()));
                          },
                          child: const Text('Update Alert'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<EmergencyAlertBloc, EmergencyAlertState>(
              builder: (context, state) {
                if (state is EmergencyAlertLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EmergencyAlertSuccess) {
                  if (state.response != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _populateFormWithAlertData(state.response);
                    });
                  }

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                    'Response', state.response.toString()),
                                const SizedBox(height: 10),
                                if (state.response != null)
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Form filled with fetched data!'),
                                        ),
                                      );
                                    },
                                    child:
                                        const Text('Data loaded successfully'),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is EmergencyAlertFailure) {
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
