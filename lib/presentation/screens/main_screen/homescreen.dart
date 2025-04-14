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
import 'package:elderwise/presentation/screens/agenda_screen/add_agenda.dart';
import 'package:elderwise/presentation/screens/agenda_screen/agenda_page.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/screens/main_screen/main_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/utils/toast_helper.dart';
import 'package:elderwise/presentation/widgets/homescreen/greeting_section.dart';
import 'package:elderwise/presentation/widgets/homescreen/profile_header.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

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

  String _userName = "User";
  String? _elderPhotoUrl;
  String? _caregiverPhotoUrl;
  UserMode _currentMode = UserMode.caregiver;
  dynamic _elderData;
  dynamic _caregiverData;

  late GoogleMapController? _googleMapController;
  bool _mapInitialized = false;
  Set<Marker> _markers = {};
  LatLng _centerLatLng = const LatLng(-7.9996, 112.629);
  double _mandiriRadius = 5.0;
  double _pantauRadius = 10.0;
  BitmapDescriptor _mapMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

  @override
  void initState() {
    super.initState();
    context.read<UserModeBloc>().add(InitializeUserModeEvent());
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
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    _updateMarker();
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('elderLocation'),
          position: _centerLatLng,
          icon: _mapMarkerIcon,
          draggable: false,
          infoWindow: InfoWindow(
            title: 'Lokasi Elder',
            snippet: _userName,
          ),
        ),
      };
    });
  }

  double _calculateZoomLevel(double radiusInKm) {
    return 13.0 - (radiusInKm / 5.0);
  }

  void _loadUserData() {
    if (_userId.isNotEmpty && !_userDataLoaded) {
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
              zoom: _calculateZoomLevel(_pantauRadius),
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
                  zoom: _calculateZoomLevel(_pantauRadius),
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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

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
        body: SafeArea(
          child: Container(
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
                  padding: EdgeInsets.fromLTRB(
                      32.0, screenHeight * 0.02, 32.0, 16.0),
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
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
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.location_on,
                                        color: AppColors.neutral90,
                                        size: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Lokasi Elder",
                                        style: TextStyle(
                                          color: AppColors.neutral90,
                                          fontSize: 22,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: screenHeight * 0.25,
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral40,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      children: [
                                        FenceMapWidget(
                                          initialCameraPosition: CameraPosition(
                                            target: _centerLatLng,
                                            zoom: _calculateZoomLevel(
                                                _pantauRadius),
                                          ),
                                          onMapCreated: (controller) {
                                            _googleMapController = controller;
                                            _mapInitialized = true;
                                            _updateMarker();
                                          },
                                          markers: _markers,
                                          circles: {
                                            Circle(
                                              circleId:
                                                  const CircleId('mandiriArea'),
                                              center: _centerLatLng,
                                              radius: _mandiriRadius * 1000,
                                              fillColor: AppColors.primaryMain
                                                  .withOpacity(0.1),
                                              strokeColor:
                                                  AppColors.primaryMain,
                                              strokeWidth: 2,
                                            ),
                                            if (_pantauRadius > _mandiriRadius)
                                              Circle(
                                                circleId: const CircleId(
                                                    'pantauArea'),
                                                center: _centerLatLng,
                                                radius: _pantauRadius * 1000,
                                                fillColor: AppColors.primaryMain
                                                    .withOpacity(0.05),
                                                strokeColor:
                                                    AppColors.primaryMain,
                                                strokeWidth: 1,
                                              ),
                                          },
                                          myLocationEnabled: true,
                                          zoomControlsEnabled: false,
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: FloatingActionButton.small(
                                            backgroundColor:
                                                AppColors.primaryMain,
                                            onPressed: _getCurrentLocation,
                                            elevation: 2,
                                            child: const Icon(
                                              Icons.my_location,
                                              color: AppColors.neutral90,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.event_note,
                                            color: AppColors.neutral90,
                                            size: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Agenda",
                                            style: TextStyle(
                                              color: AppColors.neutral90,
                                              fontSize: 22,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          MainScreen.mainScreenKey.currentState
                                              ?.changeTab(1);
                                        },
                                        child: const Text(
                                          "Lihat Semua",
                                          style: TextStyle(
                                            color: AppColors.neutral90,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.15,
                                  child: _agendas.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "Tidak ada agenda untuk saat ini",
                                            style: TextStyle(
                                              color: AppColors.neutral70,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _agendas.length > 5
                                              ? 5
                                              : _agendas.length,
                                          itemBuilder: (context, index) {
                                            final agenda = _agendas[index];
                                            final type =
                                                agenda.category.toLowerCase();
                                            final time = DateFormat('HH:mm')
                                                .format(agenda.datetime);
                                            String iconFile;

                                            switch (type) {
                                              case 'obat':
                                                iconFile = 'medicine.png';
                                                break;
                                              case 'makan':
                                                iconFile = 'food.png';
                                                break;
                                              case 'hidrasi':
                                                iconFile = 'hidration.png';
                                                break;
                                              case 'aktivitas':
                                                iconFile = 'activity.png';
                                                break;
                                              default:
                                                iconFile = 'medicine.png';
                                            }

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddAgenda(
                                                      agendaId: agenda.agendaId,
                                                      category: agenda.category,
                                                      content1: agenda.content1,
                                                      content2: agenda.content2,
                                                      timeStr:
                                                          '${agenda.datetime.hour}:${agenda.datetime.minute}',
                                                    ),
                                                  ),
                                                ).then((result) {
                                                  if (result == true) {
                                                    _loadAgendas();
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  width: 72,
                                                  height: screenHeight * 0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    color: AppColors
                                                        .secondarySurface,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        blurRadius: 3,
                                                        color:
                                                            AppColors.neutral30,
                                                        spreadRadius: 0,
                                                        offset: Offset(1, 3),
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(iconImages +
                                                          iconFile),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              agenda.category[0]
                                                                      .toUpperCase() +
                                                                  agenda
                                                                      .category
                                                                      .substring(
                                                                          1)
                                                                      .toLowerCase(),
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColors
                                                                    .neutral90,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    size: 10,
                                                                    color: AppColors
                                                                        .neutral90,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  time,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: AppColors
                                                                        .neutral90,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
