import 'package:elderwise/presentation/screens/profile_screen/profile_screen.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofenceScreen extends StatefulWidget {
  const GeofenceScreen({super.key});

  @override
  State<GeofenceScreen> createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> {
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(-7.9996, 112.629),
  zoom: 13);

  late GoogleMapController _googleMapController;

  @override
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/presentation/screens/assets/images/bg_floral.png',
            ),
            fit: BoxFit.cover,
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
                      color: AppColors.neutral20,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        MainButton(
                          buttonText: "Atur Area",
                          onTap: () {},
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
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 275,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                ),
                                child: GoogleMap(
                                  myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    initialCameraPosition: _initialCameraPosition,
                                  onMapCreated: (controller) => _googleMapController = controller,)
                              )
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Titik Pusat       :  69 LU - 420 BT",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      color: AppColors.neutral90,
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  Text(
                                    "Area Mandiri  :  10 Km",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      color: AppColors.neutral90,
                                    ),
                                    ),SizedBox(height: 16,),
                                  Text(
                                      "Area Pantau   :  5 Km",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                        color: AppColors.neutral90,
                                      ),
                                    ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                                child: MainButton(buttonText: "Beri Peringatan", color: AppColors.neutral20, onTap: (){
                                  _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
                                }),
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
    );
  }
}