import 'dart:async';

import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/formfield.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_map_widget.dart';
import 'package:elderwise/presentation/widgets/geofence/radius_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';

class SetFenceScreen extends StatefulWidget {
  final double initialMandiriRadius;
  final double initialPantauRadius;
  final LatLng? initialCenter;

  const SetFenceScreen({
    super.key,
    this.initialMandiriRadius = 5.0,
    this.initialPantauRadius = 10.0,
    this.initialCenter,
  });

  @override
  State<SetFenceScreen> createState() => _SetFenceScreenState();
}

class _SetFenceScreenState extends State<SetFenceScreen> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(-7.9996, 112.629), zoom: 10);

  late GoogleMapController? _googleMapController;
  bool _mapInitialized = false;

  late double _mandiriRadius;
  late double _pantauRadius;

  final Set<Circle> _circles = {};
  final Set<Marker> _markers = {};
  late LatLng _center;
  late BitmapDescriptor _centerMarkerIcon;

  @override
  void initState() {
    super.initState();
    _mandiriRadius = widget.initialMandiriRadius;
    _pantauRadius = widget.initialPantauRadius;
    _center = widget.initialCenter ?? const LatLng(-7.9996, 112.629);

    _centerMarkerIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    _initMarkerIcon();
  }

  void _initMarkerIcon() {
    _centerMarkerIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

    _initializeCircles();

    if (widget.initialCenter == null) {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    if (_mapInitialized) {
      _googleMapController?.dispose();
    }
    super.dispose();
  }

  double _calculateZoomLevel(double radiusInKm) {
    return 13.0 - (radiusInKm / 5.0);
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Layanan lokasi tidak aktif. Silakan aktifkan GPS Anda.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin lokasi ditolak')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Izin lokasi ditolak secara permanen, silakan ubah di pengaturan')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mendapatkan lokasi Anda...'),
          duration: Duration(seconds: 2),
        ),
      );

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).catchError((error) {
        if (error is TimeoutException) {
          throw 'Waktu mendapatkan lokasi habis. Silakan coba lagi.';
        }
        throw error.toString();
      });

      if (!mounted) return;

      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });

      _updateCircles();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi berhasil diperbarui'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'Gagal mendapatkan lokasi: $e';
      if (e.toString().contains('PERMISSION_DENIED')) {
        errorMessage = 'Tidak dapat mengakses lokasi: izin ditolak';
      } else if (e.toString().contains('POSITION_UNAVAILABLE')) {
        errorMessage = 'Lokasi tidak tersedia saat ini';
      } else if (e.toString().contains('TIMEOUT')) {
        errorMessage = 'Waktu mendapatkan lokasi habis';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void _initializeCircles() {
    setState(() {
      _circles.clear();
      _markers.clear();

      _markers.add(
        Marker(
          markerId: const MarkerId('centerPoint'),
          position: _center,
          draggable: true,
          icon: _centerMarkerIcon,
          onDragEnd: (newPosition) {
            setState(() {
              _center = newPosition;
              _updateCircles();
            });
          },
        ),
      );

      _circles.add(
        Circle(
          circleId: const CircleId('mandiriArea'),
          center: _center,
          radius: _mandiriRadius * 1000,
          fillColor: AppColors.primaryMain.withOpacity(0.1),
          strokeColor: AppColors.primaryMain,
          strokeWidth: 2,
        ),
      );

      if (_pantauRadius > _mandiriRadius) {
        _circles.add(
          Circle(
            circleId: const CircleId('pantauArea'),
            center: _center,
            radius: _pantauRadius * 1000,
            fillColor: AppColors.primaryMain.withOpacity(0.05),
            strokeColor: AppColors.primaryMain,
            strokeWidth: 1,
          ),
        );
      }
    });
  }

  void _updateCircles() {
    _initializeCircles();

    if (_mapInitialized && _googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _center,
            zoom: _calculateZoomLevel(_pantauRadius),
          ),
        ),
      );
    }
  }

  String _formatCoordinates(LatLng position) {
    final lat = position.latitude.toStringAsFixed(4);
    final lng = position.longitude.toStringAsFixed(4);
    return "$lat° ${position.latitude >= 0 ? 'LU' : 'LS'} - $lng° ${position.longitude >= 0 ? 'BT' : 'BB'}";
  }

  @override
  Widget build(BuildContext context) {
    final userModeState = context.watch<UserModeBloc>().state;
    final isElderMode = userModeState.userMode == UserMode.elder;

    if (isElderMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        ToastHelper.showErrorToast(
            context, 'Anda tidak dapat mengubah area saat dalam Mode Elder');
      });
      return Container();
    }

    return Scaffold(
      backgroundColor: AppColors.primaryMain,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                        'Atur Area',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral90,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop({
                            'centerPoint': _formatCoordinates(_center),
                            'mandiriRadius': _mandiriRadius,
                            'pantauRadius': _pantauRadius,
                            'centerLatLng': _center,
                          });
                        },
                        child: const Text(
                          "SIMPAN",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral90,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.secondarySurface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Pilih lokasi pusat area lansia Anda:",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const CustomFormField(hintText: "Pilih lokasi anda"),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppColors.neutral30,
                                  width: 1,
                                )),
                            width: double.infinity,
                            height: 300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                children: [
                                  FenceMapWidget(
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: _calculateZoomLevel(_pantauRadius),
                                    ),
                                    onMapCreated: (controller) {
                                      _googleMapController = controller;
                                      _mapInitialized = true;
                                      _updateCircles();
                                    },
                                    circles: _circles,
                                    markers: _markers,
                                    zoomControlsEnabled: true,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: true,
                                    onTap: (LatLng position) {
                                      setState(() {
                                        _center = position;
                                      });
                                      _updateCircles();
                                    },
                                    height: 300,
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "Tap untuk memilih titik pusat atau geser marker",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: RadiusSliderWidget(
                              label: "Area Mandiri",
                              value: _mandiriRadius,
                              max: 15.0,
                              description:
                                  "Lansia dapat dengan bebas beraktifitas secara mandiri dalam radius berikut:",
                              onChanged: (value) {
                                setState(() {
                                  _mandiriRadius = value;
                                  if (_pantauRadius < _mandiriRadius) {
                                    _pantauRadius = _mandiriRadius;
                                  }
                                  _updateCircles();
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: RadiusSliderWidget(
                              label: "Area Pantau",
                              value: _pantauRadius,
                              max: 20.0,
                              divisions: 200,
                              maxLabel: "20 KM",
                              description:
                                  "Lansia dapat beraktifitas dengan pantauan dari caregiver dalam radius berikut:",
                              onChanged: (value) {
                                setState(() {
                                  _pantauRadius = value;
                                  if (_pantauRadius < _mandiriRadius) {
                                    _mandiriRadius = _pantauRadius;
                                  }
                                  _updateCircles();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryMain,
        child: const Icon(Icons.my_location, color: AppColors.neutral90),
        onPressed: _getCurrentLocation,
      ),
    );
  }
}
