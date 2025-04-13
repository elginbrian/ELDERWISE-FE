import 'package:elderwise/data/api/requests/area_request.dart';
import 'package:elderwise/presentation/bloc/area/area_bloc.dart';
import 'package:elderwise/presentation/bloc/area/area_event.dart';
import 'package:elderwise/presentation/bloc/area/area_state.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/screens/geofence_screen/set_fence_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_info_widget.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';

class GeofenceScreen extends StatefulWidget {
  const GeofenceScreen({super.key});

  @override
  State<GeofenceScreen> createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-7.9996, 112.629),
    zoom: 13,
  );

  late GoogleMapController? _googleMapController;
  bool _mapInitialized = false;
  String _userId = '';
  String _caregiverId = '';
  String _elderId = '';
  String _areaId = '';
  bool _isLoading = true;

  String _centerPoint = "-7.9996° LS - 112.6290° BT";
  double _mandiriRadius = 5.0;
  double _pantauRadius = 10.0;
  LatLng _centerLatLng = const LatLng(-7.9996, 112.629);

  Set<Marker> _markers = {};
  BitmapDescriptor _centerMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _initMarkerIcon();
  }

  void _initMarkerIcon() {
    // Just use the default yellow marker
    _centerMarkerIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

    // Update marker immediately
    _updateMarker();

    // Get location
    _getCurrentLocation();
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('centerPoint'),
          position: _centerLatLng,
          icon: _centerMarkerIcon,
          draggable: true,
          onDragEnd: (newPosition) {
            setState(() {
              _centerLatLng = newPosition;
              _centerPoint = _formatCoordinates(newPosition);
            });
            _updateMarker();
          },
        ),
      };
    });
  }

  void _loadCurrentUser() {
    context.read<AuthBloc>().add(GetCurrentUserEvent());
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ToastHelper.showErrorToast(context, 'Izin lokasi ditolak');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ToastHelper.showErrorToast(context,
            'Izin lokasi ditolak secara permanen, silakan ubah di pengaturan');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _centerLatLng = LatLng(position.latitude, position.longitude);
        _centerPoint = _formatCoordinates(_centerLatLng);
      });

      _updateMarker();

      // Update camera if map is initialized
      if (_mapInitialized && _googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _centerLatLng,
              zoom: _calculateZoomLevel(_pantauRadius),
            ),
          ),
        );
      }
    } catch (e) {
      ToastHelper.showErrorToast(context, 'Gagal mendapatkan lokasi: $e');
    }
  }

  void _updateFenceData({
    String? centerPoint,
    double? mandiriRadius,
    double? pantauRadius,
    LatLng? centerLatLng,
  }) {
    setState(() {
      if (centerPoint != null) _centerPoint = centerPoint;
      if (mandiriRadius != null) _mandiriRadius = mandiriRadius;
      if (pantauRadius != null) _pantauRadius = pantauRadius;
      if (centerLatLng != null) _centerLatLng = centerLatLng;
    });

    _updateMarker();

    // Only update camera if map is initialized and controller exists
    if (pantauRadius != null &&
        _mapInitialized &&
        _googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _centerLatLng,
            zoom: _calculateZoomLevel(pantauRadius),
          ),
        ),
      );
    }
  }

  double _calculateZoomLevel(double radiusInKm) {
    // More zoomed out to ensure better visibility of the entire area
    return 13.0 - (radiusInKm / 5.0);
  }

  void _saveArea() {
    if (_caregiverId.isEmpty) {
      ToastHelper.showErrorToast(context, 'Caregiver ID tidak ditemukan');
      return;
    }

    if (_elderId.isEmpty) {
      ToastHelper.showErrorToast(context, 'Elder ID tidak ditemukan');
      return;
    }

    final areaRequest = AreaRequestDTO(
      caregiverId: _caregiverId,
      elderId: _elderId,
      centerLat: _centerLatLng.latitude,
      centerLong: _centerLatLng.longitude,
      freeAreaRadius: _mandiriRadius.round(),
      watchAreaRadius: _pantauRadius.round(),
      isActive: true,
    );

    if (_areaId.isEmpty) {
      context.read<AreaBloc>().add(CreateAreaEvent(areaRequest));
    } else {
      context.read<AreaBloc>().add(UpdateAreaEvent(_areaId, areaRequest));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModeState = context.watch<UserModeBloc>().state;
    final isElderMode = userModeState.userMode == UserMode.elder;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CurrentUserSuccess) {
              setState(() {
                _userId = state.user.user.userId;
              });
              context.read<UserBloc>().add(GetUserCaregiversEvent(_userId));
              context.read<UserBloc>().add(GetUserEldersEvent(_userId));
            } else if (state is AuthFailure) {
              setState(() => _isLoading = false);
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isLoading = false);

              if (state.response.data != null &&
                  state.response.data is Map &&
                  state.response.data.containsKey('caregivers') &&
                  state.response.data['caregivers'].isNotEmpty) {
                final caregiverId = state.response.data['caregivers'][0]
                        ['caregiver_id'] ??
                    state.response.data['caregivers'][0]['id'];
                setState(() {
                  _caregiverId = caregiverId;
                });

                context
                    .read<AreaBloc>()
                    .add(GetAreasByCaregiverEvent(caregiverId));
              }

              if (state.response.data != null &&
                  state.response.data is Map &&
                  state.response.data.containsKey('elders') &&
                  state.response.data['elders'].isNotEmpty) {
                final elderId = state.response.data['elders'][0]['elder_id'] ??
                    state.response.data['elders'][0]['id'];
                setState(() {
                  _elderId = elderId;
                });
              }
            } else if (state is UserFailure) {
              setState(() => _isLoading = false);
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
        BlocListener<AreaBloc, AreaState>(
          listener: (context, state) {
            if (state is AreasSuccess) {
              if (state.areas.areas.isNotEmpty) {
                final area = state.areas.areas[0];
                final latLng = LatLng(area.centerLat, area.centerLong);
                setState(() {
                  _areaId = area.areaId;
                  _mandiriRadius = area.freeAreaRadius.toDouble();
                  _pantauRadius = area.watchAreaRadius.toDouble();
                  _centerLatLng = latLng;
                  _centerPoint = _formatCoordinates(latLng);
                });

                _updateMarker();

                // Only update camera if map is initialized
                if (_mapInitialized && _googleMapController != null) {
                  _googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: latLng,
                        zoom: _calculateZoomLevel(
                            area.watchAreaRadius.toDouble()),
                      ),
                    ),
                  );
                }
              }
            } else if (state is AreaSuccess) {
              ToastHelper.showSuccessToast(context, 'Area berhasil disimpan');
            } else if (state is AreaFailure) {
              ToastHelper.showErrorToast(context, state.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryMain,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Row(
                  children: [
                    const Text(
                      'Geofence',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.neutral90,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.secondarySurface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            if (!isElderMode)
                              MainButton(
                                buttonText: "Atur Area",
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SetFenceScreen(
                                        initialMandiriRadius: _mandiriRadius,
                                        initialPantauRadius: _pantauRadius,
                                        initialCenter: _centerLatLng,
                                      ),
                                    ),
                                  );

                                  if (result != null &&
                                      result is Map<String, dynamic>) {
                                    _updateFenceData(
                                      centerPoint: result['centerPoint'],
                                      mandiriRadius: result['mandiriRadius'],
                                      pantauRadius: result['pantauRadius'],
                                      centerLatLng: result['centerLatLng'],
                                    );

                                    // Show indicator that changes need to be saved
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Perubahan belum disimpan. Klik "Simpan Area" untuk menyimpan.'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                              ),
                            const SizedBox(height: 32),
                            Container(
                              width: double.infinity,
                              height: 500,
                              decoration: BoxDecoration(
                                color: AppColors.secondarySurface,
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(
                                  color: AppColors.neutral30,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      FenceMapWidget(
                                        initialCameraPosition:
                                            _initialCameraPosition,
                                        onMapCreated: (controller) {
                                          _googleMapController = controller;
                                          _mapInitialized = true;
                                          _updateMarker();

                                          // Initially set zoom based on pantau radius
                                          controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                target: _centerLatLng,
                                                zoom: _calculateZoomLevel(
                                                    _pantauRadius),
                                              ),
                                            ),
                                          );
                                        },
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(32),
                                          topRight: Radius.circular(32),
                                        ),
                                        markers: _markers,
                                        circles: {
                                          Circle(
                                            circleId:
                                                const CircleId('mandiriArea'),
                                            center: _centerLatLng,
                                            radius: _mandiriRadius * 1000,
                                            fillColor: AppColors.primaryMain
                                                .withOpacity(0.1),
                                            strokeColor: AppColors.primaryMain,
                                            strokeWidth: 2,
                                          ),
                                          if (_pantauRadius > _mandiriRadius)
                                            Circle(
                                              circleId:
                                                  const CircleId('pantauArea'),
                                              center: _centerLatLng,
                                              radius: _pantauRadius * 1000,
                                              fillColor: AppColors.primaryMain
                                                  .withOpacity(0.05),
                                              strokeColor:
                                                  AppColors.primaryMain,
                                              strokeWidth: 1,
                                            ),
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FenceInfoWidget(
                                      centerPoint: _centerPoint,
                                      mandiriRadius: _mandiriRadius,
                                      pantauRadius: _pantauRadius,
                                    ),
                                  ),
                                  if (!isElderMode)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16, bottom: 16),
                                      child: MainButton(
                                        buttonText: "Simpan Area",
                                        onTap: _saveArea,
                                      ),
                                    )
                                ],
                              ),
                            )
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

  String _formatCoordinates(LatLng position) {
    final lat = position.latitude.toStringAsFixed(4);
    final lng = position.longitude.toStringAsFixed(4);
    return "$lat° ${position.latitude >= 0 ? 'LU' : 'LS'} - $lng° ${position.longitude >= 0 ? 'BT' : 'BB'}";
  }
}
