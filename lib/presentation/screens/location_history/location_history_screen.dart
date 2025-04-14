import 'package:elderwise/data/api/responses/location_history_response.dart';
import 'package:elderwise/domain/entities/location_history_point.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_bloc.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_event.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_state.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class LocationHistoryScreen extends StatefulWidget {
  final String elderId;

  const LocationHistoryScreen({
    Key? key,
    required this.elderId,
  }) : super(key: key);

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  String? _locationHistoryId;
  List<LocationHistoryPoint> _historyPoints = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    _loadLocationHistory();
  }

  void _loadLocationHistory() {
    context.read<LocationHistoryBloc>().add(
          GetElderLocationHistoryEvent(
            elderId: widget.elderId,
            date: _selectedDate,
          ),
        );
  }

  void _updateMapMarkers() {
    if (_historyPoints.isEmpty) return;

    setState(() {
      _markers = _historyPoints.asMap().entries.map((entry) {
        int idx = entry.key;
        LocationHistoryPoint point = entry.value;

        return Marker(
          markerId: MarkerId('point_$idx'),
          position: LatLng(point.latitude, point.longitude),
          infoWindow: InfoWindow(
            title: 'Lokasi #${idx + 1}',
            snippet: _timeFormat.format(point.timestamp),
          ),
        );
      }).toSet();
    });

    if (_mapController != null && _historyPoints.isNotEmpty) {
      final recentPoint = _historyPoints.first;
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(recentPoint.latitude, recentPoint.longitude),
          15.0,
        ),
      );
    }
  }

  void _handleDateSelection() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryMain,
            colorScheme: ColorScheme.light(primary: AppColors.primaryMain),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _isLoading = true;
      });
      _loadLocationHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationHistoryBloc, LocationHistoryState>(
      listener: (context, state) {
        if (state is LocationHistoryLoading) {
          setState(() => _isLoading = true);
        } else if (state is LocationHistorySuccess) {
          setState(() {
            _locationHistoryId =
                state.response.locationHistory.locationHistoryId;
            _isLoading = false;
          });

          if (_locationHistoryId != null) {
            context.read<LocationHistoryBloc>().add(
                  GetLocationHistoryPointsEvent(_locationHistoryId!),
                );
          }
        } else if (state is LocationHistoryPointsSuccess) {
          setState(() {
            _historyPoints = state.response.points;
            _isLoading = false;
          });
          _updateMapMarkers();
        } else if (state is LocationHistoryFailure) {
          setState(() => _isLoading = false);
          debugPrint("Failed to load location history: ${state.error}");
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryMain,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios,
                          color: AppColors.neutral90),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Riwayat Lokasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.neutral90,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.secondarySurface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tanggal: ${_dateFormat.format(_selectedDate)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: AppColors.neutral90,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _handleDateSelection,
                              icon: const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: AppColors.neutral90,
                              ),
                              label: const Text(
                                'Pilih Tanggal',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AppColors.neutral90,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryMain,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _historyPoints.isEmpty
                                ? const Center(
                                    child: Text(
                                    'Tidak ada data riwayat lokasi untuk tanggal ini',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ))
                                : Column(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: GoogleMap(
                                              initialCameraPosition:
                                                  const CameraPosition(
                                                target:
                                                    LatLng(-7.9996, 112.629),
                                                zoom: 10,
                                              ),
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                _mapController = controller;
                                                _updateMapMarkers();
                                              },
                                              markers: _markers,
                                              myLocationButtonEnabled: false,
                                              zoomControlsEnabled: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Riwayat Lokasi',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins',
                                                  color: AppColors.neutral90,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                '${_historyPoints.length} titik lokasi ditemukan',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  color: AppColors.neutral60,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      _historyPoints.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final point =
                                                        _historyPoints[index];
                                                    return _buildLocationHistoryItem(
                                                        point, index);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHistoryItem(LocationHistoryPoint point, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryMain,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        title: Text(
          'Lokasi #${index + 1}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waktu: ${_timeFormat.format(point.timestamp)}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            Text(
              'Koordinat: ${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
            ),
          ],
        ),
        onTap: () {
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(point.latitude, point.longitude),
                16.0,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
