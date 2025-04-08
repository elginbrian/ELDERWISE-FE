import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class SetFenceScreen extends StatefulWidget {
  const SetFenceScreen({super.key});

  @override
  State<SetFenceScreen> createState() => _SetFenceScreenState();
}

class _SetFenceScreenState extends State<SetFenceScreen> {
  static const _initialCameraPosition =
  CameraPosition(target: LatLng(-7.9996, 112.629), zoom: 10);

  late GoogleMapController _googleMapController;

  double _mandiriRadius = 5.0;
  double _pantauRadius = 10.0;

  final Set<Circle> _circles = {};
  final Set<Marker> _markers = {};
  LatLng _center = const LatLng(-7.9996, 112.629);

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

  @override
  void initState() {
    super.initState();
    // Initialize circles and markers
    _updateCircles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondarySurface,
      appBar: AppBar(
        title: const Text("Atur Area"),
        leading: const Icon(Icons.arrow_back_ios),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "SIMPAN",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CustomFormField(hintText: "Pilih lokasi anda"),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
              width: double.infinity,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      initialCameraPosition: _initialCameraPosition,
                      circles: _circles,
                      markers: _markers,
                      onMapCreated: (controller) {
                        _googleMapController = controller;
                      },
                      onTap: (LatLng position) {
                        setState(() {
                          _center = position;
                          _updateCircles();
                        });
                      },
                    ),
                    // Instructions overlay
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Area Mandiri",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.neutral90),
                        ),
                        child: Center(
                          child: Text(
                            "${_mandiriRadius.toStringAsFixed(1)} KM",
                          ),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Lansia dapat dengan bebas beraktifitas secara mandiri dalam radius berikut:",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                      activeTrackColor: AppColors.primaryMain,
                      inactiveTrackColor: AppColors.neutral20,
                      thumbColor: AppColors.primaryMain,
                    ),
                    child: Slider(
                      min: 0.1,
                      max: 15.0,
                      divisions: 150,
                      value: _mandiriRadius,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("0.5 KM"),
                        const Text("15 KM"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Area Pantau",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.neutral90),
                        ),
                        child: Center(
                          child: Text(
                            "${_pantauRadius.toStringAsFixed(1)} KM",
                          ),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Lansia dapat beraktifitas dengan pantauan dari caregiver dalam radius berikut:",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                      activeTrackColor: AppColors.primaryMain,
                      inactiveTrackColor: AppColors.neutral20,
                      thumbColor: AppColors.primaryMain,
                    ),
                    child: Slider(
                      min: 0.1,
                      max: 20.0,
                      divisions: 200,
                      value: _pantauRadius,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("0.5 KM"),
                        const Text("20 KM"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}