import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk simulasi database
    final List<Map<String, String>> agendaList = [
      {'type': 'makan', 'time': '19:00'},
      {'type': 'obat', 'time': '08:00'},
      {'type': 'aktivitas', 'time': '15:30'},
      {'type': 'hidrasi', 'time': '10:00'},
      {'type': 'tidur', 'time': '21:00'},
      {'type': 'tidur', 'time': '21:00'},
      {'type': 'tidur', 'time': '21:00'},
    ];

    return Scaffold(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondarySurface,
                                spreadRadius: 3,
                                blurRadius: 0,
                              )
                            ],
                          ),
                          child: Image.asset(iconImages + 'google.png'),
                        ),
                        Image.asset(
                          iconImages + 'notif.png',
                          width: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Halo, ",
                                  style: TextStyle(
                                    color: AppColors.neutral90,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text: "Elgin",
                                  style: TextStyle(
                                    color: AppColors.neutral90,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Pantau aktivitas elder anda!",
                            style: TextStyle(
                              color: AppColors.neutral90,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    )
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(iconImages + 'location.png'),
                          SizedBox(width: 4),
                          Text(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(iconImages + 'agenda.png'),
                              SizedBox(width: 4),
                              Text(
                                "Agenda",
                                style: TextStyle(
                                  color: AppColors.neutral90,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
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
                      height: 128,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: agendaList.length,
                        itemBuilder: (context, index) {
                          final item = agendaList[index];
                          final type = item['type'] ?? '';
                          final time = item['time'] ?? '';
                          String iconFile;

                          switch (type.toLowerCase()) {
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

                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: 72,
                              height: 128,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.secondarySurface,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: AppColors.neutral30,
                                    spreadRadius: 0,
                                    offset: Offset(1, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Image.asset(iconImages + iconFile),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          type[0].toUpperCase() + type.substring(1), // Capitalize
                                          style: TextStyle(
                                            color: AppColors.neutral90,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4.0),
                                              child: Image.asset(iconImages + 'clock2.png'),
                                            ),
                                            Text(
                                              time,
                                              style: TextStyle(
                                                color: AppColors.neutral90,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
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
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
