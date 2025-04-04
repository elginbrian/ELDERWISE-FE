import 'package:elderwise/di/container.dart';
import 'package:elderwise/data/api/app_config.dart';
import 'package:elderwise/domain/entities/elder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_bloc.dart';
import 'package:elderwise/presentation/bloc/elder/elder_event.dart';
import 'package:elderwise/presentation/bloc/elder/elder_state.dart';
import 'package:get_it/get_it.dart';

class TestElderScreen extends StatefulWidget {
  const TestElderScreen({Key? key}) : super(key: key);

  @override
  _TestElderScreenState createState() => _TestElderScreenState();
}

class _TestElderScreenState extends State<TestElderScreen> {
  final TextEditingController _elderIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bodyHeightController = TextEditingController();
  final TextEditingController _bodyWeightController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  DateTime _selectedBirthdate =
      DateTime.now().subtract(const Duration(days: 25550));
  bool _isLoading = true;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _ensureInitialization();
    _birthdateController.text =
        _selectedBirthdate.toIso8601String().split('T')[0];
  }

  Future<void> _ensureInitialization() async {
    setState(() {
      _isLoading = true;
      _initError = null;
    });

    try {
      await appConfig.initialize();

      if (!GetIt.instance.isRegistered<ElderBloc>()) {
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

  void _populateFormWithElderData(Elder elder) {
    if (elder == null) return;

    setState(() {
      _elderIdController.text = elder.elderId ?? '';
      _userIdController.text = elder.userId ?? '';
      _nameController.text = elder.name ?? '';
      if (elder.birthdate != null) {
        _selectedBirthdate = elder.birthdate!;
        _birthdateController.text =
            _selectedBirthdate.toIso8601String().split('T')[0];
      }
      _genderController.text = elder.gender ?? '';
      _bodyHeightController.text = elder.bodyHeight?.toString() ?? '';
      _bodyWeightController.text = elder.bodyWeight?.toString() ?? '';
      _photoUrlController.text = elder.photoUrl ?? '';
    });
  }

  @override
  void dispose() {
    _elderIdController.dispose();
    _userIdController.dispose();
    _nameController.dispose();
    _birthdateController.dispose();
    _genderController.dispose();
    _bodyHeightController.dispose();
    _bodyWeightController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text =
            _selectedBirthdate.toIso8601String().split('T')[0];
      });
    }
  }

  Elder _buildElderRequest() {
    return Elder(
      elderId: _elderIdController.text,
      userId: _userIdController.text,
      name: _nameController.text,
      birthdate: _selectedBirthdate,
      gender: _genderController.text,
      bodyHeight: double.tryParse(_bodyHeightController.text) ?? 0.0,
      bodyWeight: double.tryParse(_bodyWeightController.text) ?? 0.0,
      photoUrl: _photoUrlController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Elder')),
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
    return BlocProvider<ElderBloc>(
      create: (_) {
        try {
          return getIt<ElderBloc>();
        } catch (e) {
          print('Error creating ElderBloc: $e');
          throw Exception('Could not initialize ElderBloc: $e');
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
                    Text('Elder Information',
                        style: Theme.of(context).textTheme.titleMedium),
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
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _birthdateController,
                      decoration: const InputDecoration(
                        labelText: 'Birthdate (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: _selectBirthdate,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _genderController,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _bodyHeightController,
                            decoration: const InputDecoration(
                              labelText: 'Body Height',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _bodyWeightController,
                            decoration: const InputDecoration(
                              labelText: 'Body Weight',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _photoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Photo URL',
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
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final elderId = _elderIdController.text;
                            if (elderId.isNotEmpty) {
                              context
                                  .read<ElderBloc>()
                                  .add(GetElderEvent(elderId));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter an Elder ID'),
                                ),
                              );
                            }
                          },
                          child: const Text('Get Elder'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_userIdController.text.isEmpty ||
                                _nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please enter User ID and Name'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<ElderBloc>()
                                .add(CreateElderEvent(_buildElderRequest()));
                          },
                          child: const Text('Create Elder'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final elderId = _elderIdController.text;
                            if (elderId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter an Elder ID'),
                                ),
                              );
                              return;
                            }
                            context.read<ElderBloc>().add(UpdateElderEvent(
                                elderId, _buildElderRequest()));
                          },
                          child: const Text('Update Elder'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text;
                            if (userId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a User ID'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<ElderBloc>()
                                .add(GetElderAreasEvent(userId));
                          },
                          child: const Text('Get Elder Areas'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text;
                            if (userId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a User ID'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<ElderBloc>()
                                .add(GetElderLocationHistoryEvent(userId));
                          },
                          child: const Text('Get Elder Location History'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text;
                            if (userId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a User ID'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<ElderBloc>()
                                .add(GetElderAgendasEvent(userId));
                          },
                          child: const Text('Get Elder Agendas'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text;
                            if (userId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a User ID'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<ElderBloc>()
                                .add(GetElderEmergencyAlertsEvent(userId));
                          },
                          child: const Text('Get Elder Emergency Alerts'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ElderBloc, ElderState>(
              builder: (context, state) {
                if (state is ElderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ElderSuccess) {
                  if (state.elder != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _populateFormWithElderData(state.elder.elder);
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
                          Text('Elder Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          _buildDetailRow(
                              'ID', state.elder.elder.elderId ?? ''),
                          _buildDetailRow(
                              'User ID', state.elder.elder.userId ?? ''),
                          _buildDetailRow('Name', state.elder.elder.name ?? ''),
                          _buildDetailRow(
                              'Birthdate',
                              state.elder.elder.birthdate != null
                                  ? '${state.elder.elder.birthdate!.toLocal()}'
                                      .split(' ')[0]
                                  : 'N/A'),
                          _buildDetailRow(
                              'Gender', state.elder.elder.gender ?? ''),
                          _buildDetailRow('Height',
                              '${state.elder.elder.bodyHeight ?? 'N/A'}'),
                          _buildDetailRow('Weight',
                              '${state.elder.elder.bodyWeight ?? 'N/A'}'),
                          _buildDetailRow(
                              'Photo URL', state.elder.elder.photoUrl ?? 'N/A'),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Form filled with fetched data!'),
                                ),
                              );
                            },
                            child: const Text('Data loaded successfully'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is AreasSuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Elder Areas',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Text(
                              'Areas: ${state.areas.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is LocationHistorySuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Elder Location History',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Text(
                              'Location History: ${state.response.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is AgendasSuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Elder Agendas',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Text(
                              'Agendas: ${state.agendas.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is EmergencyAlertSuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Elder Emergency Alerts',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Text(
                              'Emergency Alerts: ${state.response.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is ElderFailure) {
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
