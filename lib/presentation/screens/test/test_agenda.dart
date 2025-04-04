import 'package:elderwise/data/api/app_config.dart';
import 'package:elderwise/di/container.dart';
import 'package:flutter/material.dart';
import 'package:elderwise/data/api/requests/agenda_request.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class TestAgendaScreen extends StatefulWidget {
  const TestAgendaScreen({Key? key}) : super(key: key);

  @override
  _TestAgendaScreenState createState() => _TestAgendaScreenState();
}

class _TestAgendaScreenState extends State<TestAgendaScreen> {
  final TextEditingController _agendaIdController = TextEditingController();
  final TextEditingController _elderIdController = TextEditingController();
  final TextEditingController _caregiverIdController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _content1Controller = TextEditingController();
  final TextEditingController _content2Controller = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _isFinished = false;
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

      if (!GetIt.instance.isRegistered<AgendaBloc>()) {
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

  // Add this method to populate form fields with fetched data
  void _populateFormWithAgendaData(dynamic agendaItem) {
    if (agendaItem == null) return;

    setState(() {
      _agendaIdController.text = agendaItem.id?.toString() ?? '';
      _elderIdController.text = agendaItem.elderId?.toString() ?? '';
      _caregiverIdController.text = agendaItem.caregiverId?.toString() ?? '';
      _categoryController.text = agendaItem.category ?? '';
      _content1Controller.text = agendaItem.content1 ?? '';
      _content2Controller.text = agendaItem.content2 ?? '';
      if (agendaItem.datetime != null) {
        _selectedDate = agendaItem.datetime;
      }
      _isFinished = agendaItem.isFinished ?? false;
    });
  }

  @override
  void dispose() {
    _agendaIdController.dispose();
    _elderIdController.dispose();
    _caregiverIdController.dispose();
    _categoryController.dispose();
    _content1Controller.dispose();
    _content2Controller.dispose();
    super.dispose();
  }

  AgendaRequestDTO _buildAgendaRequest() {
    return AgendaRequestDTO(
      elderId: _elderIdController.text,
      caregiverId: _caregiverIdController.text,
      category: _categoryController.text,
      content1: _content1Controller.text,
      content2: _content2Controller.text,
      datetime: _selectedDate,
      isFinished: _isFinished,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Agenda')),
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
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _initError = null;
                            });
                            _ensureInitialization();
                          },
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
    return BlocProvider<AgendaBloc>(
      create: (_) {
        try {
          return getIt<AgendaBloc>();
        } catch (e) {
          print('Error creating AgendaBloc: $e');

          throw Exception('Could not initialize AgendaBloc: $e');
        }
      },
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _agendaIdController,
                  decoration: const InputDecoration(labelText: 'Agenda ID'),
                ),
                TextField(
                  controller: _elderIdController,
                  decoration: const InputDecoration(labelText: 'Elder ID'),
                ),
                TextField(
                  controller: _caregiverIdController,
                  decoration: const InputDecoration(labelText: 'Caregiver ID'),
                ),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _content1Controller,
                  decoration: const InputDecoration(labelText: 'Content 1'),
                ),
                TextField(
                  controller: _content2Controller,
                  decoration: const InputDecoration(labelText: 'Content 2'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Datetime:'),
                    const SizedBox(width: 10),
                    Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Is Finished:'),
                    Switch(
                      value: _isFinished,
                      onChanged: (value) {
                        setState(() {
                          _isFinished = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final agendaId = _agendaIdController.text;
                        if (agendaId.isNotEmpty) {
                          context
                              .read<AgendaBloc>()
                              .add(GetAgendaEvent(agendaId));
                        }
                      },
                      child: const Text('Get Agenda'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AgendaBloc>()
                            .add(CreateAgendaEvent(_buildAgendaRequest()));
                      },
                      child: const Text('Create Agenda'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final agendaId = _agendaIdController.text;
                        if (agendaId.isNotEmpty) {
                          context.read<AgendaBloc>().add(UpdateAgendaEvent(
                              agendaId, _buildAgendaRequest()));
                        }
                      },
                      child: const Text('Update Agenda'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final agendaId = _agendaIdController.text;
                        if (agendaId.isNotEmpty) {
                          context
                              .read<AgendaBloc>()
                              .add(DeleteAgendaEvent(agendaId));
                        }
                      },
                      child: const Text('Delete Agenda'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<AgendaBloc, AgendaState>(
                  builder: (context, state) {
                    if (state is AgendaLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AgendaSuccess) {
                      if (state.agendaItem != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _populateFormWithAgendaData(state.agendaItem);
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
                              Text('Agenda Details',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const Divider(),
                              _buildDetailRow(
                                  'ID', state.agendaItem.agendaId.toString()),
                              _buildDetailRow('Elder ID',
                                  state.agendaItem.elderId.toString()),
                              _buildDetailRow('Caregiver ID',
                                  state.agendaItem.caregiverId.toString()),
                              _buildDetailRow(
                                  'Category', state.agendaItem.category),
                              _buildDetailRow(
                                  'Content 1', state.agendaItem.content1),
                              _buildDetailRow(
                                  'Content 2', state.agendaItem.content2),
                              _buildDetailRow(
                                  'Date',
                                  state.agendaItem?.datetime != null
                                      ? '${state.agendaItem!.datetime.toLocal()}'
                                          .split(' ')[0]
                                      : 'N/A'),
                              _buildDetailRow(
                                  'Is Finished',
                                  (state.agendaItem?.isFinished ?? false)
                                      ? 'Yes'
                                      : 'No'),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Form filled with fetched data!')));
                                },
                                child: const Text('Data loaded successfully'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is AgendaFailure) {
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
                          'No data fetched yet. Use the buttons above to perform an action.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Add this helper method for detail rows
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
