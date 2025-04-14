import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FenceMapWidget extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Function(GoogleMapController) onMapCreated;
  final Set<Circle>? circles;
  final Set<Marker>? markers;
  final bool zoomControlsEnabled;
  final bool myLocationButtonEnabled;
  final bool myLocationEnabled;
  final Function(LatLng)? onTap;
  final BorderRadius? borderRadius;
  final double height;

  const FenceMapWidget({
    Key? key,
    required this.initialCameraPosition,
    required this.onMapCreated,
    this.circles,
    this.markers,
    this.zoomControlsEnabled = false,
    this.myLocationButtonEnabled = false,
    this.myLocationEnabled = false,
    this.onTap,
    this.borderRadius,
    this.height = 275,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final map = GoogleMap(
      initialCameraPosition: initialCameraPosition,
      onMapCreated: onMapCreated,
      circles: circles ?? {},
      markers: markers ?? {},
      zoomControlsEnabled: zoomControlsEnabled,
      myLocationButtonEnabled: myLocationButtonEnabled,
      myLocationEnabled: myLocationEnabled,
      onTap: onTap,
    );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: borderRadius != null
          ? ClipRRect(
              borderRadius: borderRadius!,
              child: map,
            )
          : map,
    );
  }
}
