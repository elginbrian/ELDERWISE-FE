import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/geofence/fence_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapSection extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final LatLng centerLatLng;
  final double mapRadius;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;
  final VoidCallback onLocationButtonPressed;

  const LocationMapSection({
    Key? key,
    required this.initialCameraPosition,
    required this.centerLatLng,
    required this.mapRadius,
    required this.markers,
    required this.onMapCreated,
    required this.onLocationButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(iconImages + 'location.png'),
              const SizedBox(width: 4),
              const Text(
                "Lokasi Elder",
                style: TextStyle(
                  color: AppColors.neutral90,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 216,
          decoration: BoxDecoration(
            color: AppColors.neutral40,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                FenceMapWidget(
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: onMapCreated,
                  markers: markers,
                  circles: {
                    Circle(
                      circleId: const CircleId('elderArea'),
                      center: centerLatLng,
                      radius: mapRadius * 1000,
                      fillColor: AppColors.primaryMain.withOpacity(0.1),
                      strokeColor: AppColors.primaryMain,
                      strokeWidth: 2,
                    ),
                  },
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: FloatingActionButton.small(
                    backgroundColor: AppColors.secondarySurface,
                    onPressed: onLocationButtonPressed,
                    elevation: 2,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.primaryMain,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
