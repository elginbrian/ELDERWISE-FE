import 'package:elderwise/di/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/data/api/requests/area_request.dart';
import 'package:elderwise/presentation/bloc/area/area_bloc.dart';
import 'package:elderwise/presentation/bloc/area/area_event.dart';
import 'package:elderwise/presentation/bloc/area/area_state.dart';

class TestAreaScreen extends StatefulWidget {
  const TestAreaScreen({Key? key}) : super(key: key);

  @override
  _TestAreaScreenState createState() => _TestAreaScreenState();
}

class _TestAreaScreenState extends State<TestAreaScreen> {
  final TextEditingController _areaIdController = TextEditingController();
  final TextEditingController _elderIdController = TextEditingController();
  final TextEditingController _caregiverIdController = TextEditingController();
  final TextEditingController _centerLatController = TextEditingController();
  final TextEditingController _centerLongController = TextEditingController();
  final TextEditingController _freeAreaRadiusController =
      TextEditingController();
  final TextEditingController _watchAreaRadiusController =
      TextEditingController();
  bool _isActive = false;

  @override
  void dispose() {
    _areaIdController.dispose();
    _elderIdController.dispose();
    _caregiverIdController.dispose();
    _centerLatController.dispose();
    _centerLongController.dispose();
    _freeAreaRadiusController.dispose();
    _watchAreaRadiusController.dispose();
    super.dispose();
  }

  AreaRequestDTO _buildAreaRequest() {
    return AreaRequestDTO(
      elderId: _elderIdController.text,
      caregiverId: _caregiverIdController.text,
      centerLat: double.tryParse(_centerLatController.text) ?? 0.0,
      centerLong: double.tryParse(_centerLongController.text) ?? 0.0,
      freeAreaRadius: int.tryParse(_freeAreaRadiusController.text) ?? 0,
      watchAreaRadius: int.tryParse(_watchAreaRadiusController.text) ?? 0,
      isActive: _isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Area')),
      body: BlocProvider<AreaBloc>(
        create: (_) => getIt<AreaBloc>(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _areaIdController,
                decoration: const InputDecoration(labelText: 'Area ID'),
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
                controller: _centerLatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Center Latitude'),
              ),
              TextField(
                controller: _centerLongController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Center Longitude'),
              ),
              TextField(
                controller: _freeAreaRadiusController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Free Area Radius'),
              ),
              TextField(
                controller: _watchAreaRadiusController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Watch Area Radius'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Is Active'),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
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
                      final areaId = _areaIdController.text;
                      if (areaId.isNotEmpty) {
                        context.read<AreaBloc>().add(GetAreaEvent(areaId));
                      }
                    },
                    child: const Text('Get Area'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AreaBloc>()
                          .add(CreateAreaEvent(_buildAreaRequest()));
                    },
                    child: const Text('Create Area'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final areaId = _areaIdController.text;
                      if (areaId.isNotEmpty) {
                        context
                            .read<AreaBloc>()
                            .add(UpdateAreaEvent(areaId, _buildAreaRequest()));
                      }
                    },
                    child: const Text('Update Area'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final areaId = _areaIdController.text;
                      if (areaId.isNotEmpty) {
                        context.read<AreaBloc>().add(DeleteAreaEvent(areaId));
                      }
                    },
                    child: const Text('Delete Area'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final caregiverId = _caregiverIdController.text;
                      if (caregiverId.isNotEmpty) {
                        context
                            .read<AreaBloc>()
                            .add(GetAreasByCaregiverEvent(caregiverId));
                      }
                    },
                    child: const Text('Get Areas by Caregiver'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BlocBuilder<AreaBloc, AreaState>(
                builder: (context, state) {
                  if (state is AreaLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is AreaSuccess) {
                    return SingleChildScrollView(
                      child: Text(
                        'Success: ${state.area.toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  } else if (state is AreasSuccess) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Areas retrieved: ${state.areas.areas?.length ?? 0}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (state.areas.areas != null)
                            ...state.areas.areas!.map((area) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Area ID: ${area.areaId}'),
                                      Text('Elder ID: ${area.elderId}'),
                                      Text('Caregiver ID: ${area.caregiverId}'),
                                      Text(
                                          'Location: ${area.centerLat}, ${area.centerLong}'),
                                      Text(
                                          'Free Radius: ${area.freeAreaRadius}m'),
                                      Text(
                                          'Watch Radius: ${area.watchAreaRadius}m'),
                                      Text(
                                          'Active: ${area.isActive ? 'Yes' : 'No'}'),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    );
                  } else if (state is AreaFailure) {
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
