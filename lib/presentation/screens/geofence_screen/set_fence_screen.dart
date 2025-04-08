import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/formfield.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_map_widget.dart';
import 'package:elderwise/presentation/widgets/geofence/radius_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  late GoogleMapController _googleMapController;

  late double _mandiriRadius;
  late double _pantauRadius;

  final Set<Circle> _circles = {};
  final Set<Marker> _markers = {};
  late LatLng _center;

  @override
  void initState() {
    super.initState();
    // Initialize with the passed values
    _mandiriRadius = widget.initialMandiriRadius;
    _pantauRadius = widget.initialPantauRadius;
    _center = widget.initialCenter ?? const LatLng(-7.9996, 112.629);
    // Initialize circles and markers
    _updateCircles();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void _updateCircles() {
    setState(() {
      _circles.clear();
      _markers.clear();

      _markers.add(
        Marker(
          markerId: const MarkerId('centerPoint'),
          position: _center,
          draggable: true,
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
          radius: _mandiriRadius * 1000, // Convert km to meters
          fillColor: AppColors.primaryMain.withOpacity(0.1),
          strokeColor: AppColors.primaryMain,
          strokeWidth: 2,
        ),
      );

      // Add circle for Area Pantau if larger than Mandiri
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

  String _formatCoordinates(LatLng position) {
    // Format coordinates for display
    final lat = position.latitude.toStringAsFixed(4);
    final lng = position.longitude.toStringAsFixed(4);
    return "$lat° ${position.latitude >= 0 ? 'LU' : 'LS'} - $lng° ${position.longitude >= 0 ? 'BT' : 'BB'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      appBar: AppBar(
        title: const Text("Atur Area"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop(); // Back without saving
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: TextButton(
              onPressed: () {
                // Return data to GeofenceScreen
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
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CustomFormField(hintText: "Pilih lokasi anda"),
            const SizedBox(height: 16),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(24)),
              width: double.infinity,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    FenceMapWidget(
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 10,
                      ),
                      onMapCreated: (controller) {
                        _googleMapController = controller;
                      },
                      circles: _circles,
                      markers: _markers,
                      zoomControlsEnabled: true,
                      onTap: (LatLng position) {
                        setState(() {
                          _center = position;
                          _updateCircles();
                        });
                      },
                      height: 300,
                    ),
                    // Instructions overlay
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
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
          ],
        ),
      ),
    );
  }
}
