import 'package:elderwise/domain/entities/agenda.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_bloc.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_event.dart';
import 'package:elderwise/presentation/bloc/agenda/agenda_state.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/bloc/user/user_bloc.dart';
import 'package:elderwise/presentation/bloc/user/user_event.dart';
import 'package:elderwise/presentation/bloc/user/user_state.dart';
import 'package:elderwise/presentation/bloc/user_mode/user_mode_bloc.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/homescreen/agenda_list_section.dart';
import 'package:elderwise/presentation/widgets/homescreen/greeting_section.dart';
import 'package:elderwise/presentation/widgets/homescreen/location_map_section.dart';
import 'package:elderwise/presentation/widgets/homescreen/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-7.9996, 112.629),
    zoom: 13,
  );

  String _userId = '';
  String _elderId = '';
  String _caregiverId = '';
  bool _isLoading = true;
  bool _userDataLoaded = false;
  List<Agenda> _agendas = [];

  // User profile data
  String _userName = "User";
  String? _elderPhotoUrl;
  String? _caregiverPhotoUrl;
  UserMode _currentMode = UserMode.caregiver;
  dynamic _elderData;
  dynamic _caregiverData;

  // Map related variables
  late GoogleMapController? _googleMapController;
  bool _mapInitialized = false;
  Set<Marker> _markers = {};
  LatLng _centerLatLng = const LatLng(-7.9996, 112.629);
  double _mapRadius = 5.0; // Default radius in km
  BitmapDescriptor _mapMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

  @override
  void initState() {
    super.initState();
    // Initialize user mode
    context.read<UserModeBloc>().add(InitializeUserModeEvent());
    // Fetch current user
    context.read<AuthBloc>().add(GetCurrentUserEvent());
    _initMarkerIcon();
  }

  @override
  void dispose() {
    if (_mapInitialized) {
      _googleMapController?.dispose();
    }
    super.dispose();
  }

  void _initMarkerIcon() {
    _mapMarkerIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    _updateMarker();
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('elderLocation'),
          position: _centerLatLng,
          icon: _mapMarkerIcon,
          infoWindow: InfoWindow(
            title: 'Lokasi Elder',
            snippet: _userName,
          ),
        ),
      };
    });
  }

  void _loadUserData() {
    if (_userId.isNotEmpty && !_userDataLoaded) {
      // Use UserBloc instead of direct Elder/CaregiverBloc calls
      context.read<UserBloc>().add(GetUserEldersEvent(_userId));
      context.read<UserBloc>().add(GetUserCaregiversEvent(_userId));
      _userDataLoaded = true;
    }
  }

  void _loadAgendas() {
    if (_elderId.isNotEmpty) {
      context.read<AgendaBloc>().add(GetAgendasByElderIdEvent(_elderId));
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _centerLatLng = LatLng(position.latitude, position.longitude);
      });

      _updateMarker();

      if (_mapInitialized && _googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _centerLatLng,
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      ToastHelper.showErrorToast(context, 'Gagal mendapatkan lokasi: $e');
    }
  }

  void _populateElderData(dynamic elderData) {
    if (elderData == null || elderData.isEmpty) return;

    final elder = elderData[0];
    setState(() {
      _elderData = elder;
      _elderId = elder['elder_id'] ?? elder['id'] ?? '';

      if (_currentMode == UserMode.elder) {
        _userName = elder['name'] ?? "Elder";
      }

      if (elder['photo_url'] != null) {
        _elderPhotoUrl = elder['photo_url'];
      }

      // If there's location data for the elder, update the map
      if (elder['last_known_lat'] != null && elder['last_known_long'] != null) {
        double lat = 0.0;
        double lng = 0.0;

        try {
          lat = double.parse(elder['last_known_lat'].toString());
          lng = double.parse(elder['last_known_long'].toString());
          _centerLatLng = LatLng(lat, lng);
          _updateMarker();

          if (_mapInitialized && _googleMapController != null) {
            _googleMapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _centerLatLng,
                  zoom: 15,
                ),
              ),
            );
          }
        } catch (e) {
          debugPrint('Error parsing location data: $e');
        }
      } else {
        _getCurrentLocation();
      }

      if (_elderId.isNotEmpty) {
        _loadAgendas();
      }
    });
  }

  void _populateCaregiverData(dynamic caregiverData) {
    if (caregiverData == null || caregiverData.isEmpty) return;

    final caregiver = caregiverData[0];
    setState(() {
      _caregiverData = caregiver;
      _caregiverId = caregiver['caregiver_id'] ?? caregiver['id'] ?? '';

      if (_currentMode == UserMode.caregiver) {
        _userName = caregiver['name'] ?? "Caregiver";
      }

      if (caregiver['profile_url'] != null) {
        _caregiverPhotoUrl = caregiver['profile_url'];
      } else if (caregiver['photo_url'] != null) {
        _caregiverPhotoUrl = caregiver['photo_url'];
      }
    });
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
              _loadUserData();
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              setState(() => _isLoading = false);

              if (state.response.data != null && state.response.data is Map) {
                if (state.response.data.containsKey('elders') &&
                    state.response.data['elders'] is List) {
                  _populateElderData(state.response.data['elders']);
                }

                if (state.response.data.containsKey('caregivers') &&
                    state.response.data['caregivers'] is List) {
                  _populateCaregiverData(state.response.data['caregivers']);
                }
              }
            } else if (state is UserFailure) {
              setState(() => _isLoading = false);
              ToastHelper.showErrorToast(
                context,
                ToastHelper.getUserFriendlyErrorMessage(state.error),
              );
            }
          },
        ),
        BlocListener<UserModeBloc, UserModeState>(
          listener: (context, state) {
            setState(() {
              _currentMode = state.userMode;

              // Update username based on current mode
              if (_currentMode == UserMode.elder && _elderData != null) {
                _userName = _elderData['name'] ?? "Elder";
              } else if (_currentMode == UserMode.caregiver &&
                  _caregiverData != null) {
                _userName = _caregiverData['name'] ?? "Caregiver";
              }
            });
          },
        ),
        BlocListener<AgendaBloc, AgendaState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is AgendaLoading;
            });

            if (state is AgendaListSuccess) {
              setState(() {
                _agendas = state.agendas;
              });
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
              image: AssetImage(iconImages + 'bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(
                        currentMode: _currentMode,
                        elderPhotoUrl: _elderPhotoUrl,
                        caregiverPhotoUrl: _caregiverPhotoUrl,
                      ),
                      const SizedBox(height: 16),
                      GreetingSection(
                        userName: _userName,
                        currentMode: _currentMode,
                      ),
                    ],
                  ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LocationMapSection(
                              initialCameraPosition: _initialCameraPosition,
                              centerLatLng: _centerLatLng,
                              mapRadius: _mapRadius,
                              markers: _markers,
                              onMapCreated: (controller) {
                                _googleMapController = controller;
                                _mapInitialized = true;
                                _updateMarker();
                              },
                              onLocationButtonPressed: _getCurrentLocation,
                            ),
                            AgendaListSection(agendas: _agendas),
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
}
