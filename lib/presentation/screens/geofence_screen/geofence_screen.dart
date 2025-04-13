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
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/geofence_screen/set_fence_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_info_widget.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  late GoogleMapController _googleMapController;
  String _userId = '';
  String _caregiverId = '';
  String _elderId = ''; // Added elder ID state variable
  String _areaId = '';
  bool _isLoading = true;

  // Area information
  String _centerPoint = "-7.9996° LS - 112.6290° BT";
  double _mandiriRadius = 5.0;
  double _pantauRadius = 10.0;
  LatLng _centerLatLng = const LatLng(-7.9996, 112.629);

  @override
  void initState() {
    super.initState();
    // Load current user and areas when widget initializes
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    context.read<AuthBloc>().add(GetCurrentUserEvent());
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
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
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CurrentUserSuccess) {
              setState(() {
                _userId = state.user.user.userId;
              });
              // Fetch user's caregiver and elder information
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

              // Handle caregivers data
              if (state.response.data != null &&
                  state.response.data is Map &&
                  state.response.data.containsKey('caregivers') &&
                  state.response.data['caregivers'].isNotEmpty) {
                // Extract caregiver ID from response
                final caregiverId = state.response.data['caregivers'][0]
                        ['caregiver_id'] ??
                    state.response.data['caregivers'][0]['id'];
                setState(() {
                  _caregiverId = caregiverId;
                });

                // Fetch areas for this caregiver
                context
                    .read<AreaBloc>()
                    .add(GetAreasByCaregiverEvent(caregiverId));
              }

              // Handle elders data
              if (state.response.data != null &&
                  state.response.data is Map &&
                  state.response.data.containsKey('elders') &&
                  state.response.data['elders'].isNotEmpty) {
                // Extract elder ID from response
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

                // Update map camera
                _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: latLng,
                      zoom: 13,
                    ),
                  ),
                );
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                iconImages + 'bg.png'
              ),
              fit: BoxFit.cover
              // fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 128),
              Expanded(
                child: Stack(
                  children: [
                    Container(
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

                                      // Save the area to backend
                                      _saveArea();
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FenceMapWidget(
                                        initialCameraPosition:
                                            _initialCameraPosition,
                                        onMapCreated: (controller) =>
                                            _googleMapController = controller,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(32),
                                          topRight: Radius.circular(32),
                                        ),
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
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: FenceInfoWidget(
                                          centerPoint: _centerPoint,
                                          mandiriRadius: _mandiriRadius,
                                          pantauRadius: _pantauRadius,
                                        ),
                                      ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCoordinates(LatLng position) {
    // Format coordinates for display
    final lat = position.latitude.toStringAsFixed(4);
    final lng = position.longitude.toStringAsFixed(4);
    return "$lat° ${position.latitude >= 0 ? 'LU' : 'LS'} - $lng° ${position.longitude >= 0 ? 'BT' : 'BB'}";
  }
}
