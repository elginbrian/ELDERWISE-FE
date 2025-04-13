import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class HomescreenElder extends StatefulWidget {
  const HomescreenElder({super.key});

  @override
  State<HomescreenElder> createState() => _HomescreenElderState();
}

class _HomescreenElderState extends State<HomescreenElder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); 

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> agendaList = [
      {'type': 'makan', 'time': '19:00'},
    ];

    return Stack(
      children: [
        Scaffold(
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
                // Bagian atas (halo, notifikasi, dll) tetap
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
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
                          padding: const EdgeInsets.only(top: 0, bottom: 112),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  "Apa kabar anda hari ini?",
                                  style: TextStyle(
                                    color: AppColors.neutral90,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Bagian bawah (agenda)
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
                          padding:
                              const EdgeInsets.only(bottom: 8.0, top: 128),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(iconImages + 'agenda.png'),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Agenda Terdekat",
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
                          child: Builder(
                            builder: (context) {
                              final item = agendaList[0];
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

                              return Container(
                                padding: const EdgeInsets.all(16),
                                width: double.infinity,
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
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: double.infinity,
                                      child: Image.asset(
                                        iconImages + iconFile,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Paracetamol",
                                              style: TextStyle(
                                                color: AppColors.neutral90,
                                                fontSize: 24,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Text(
                                                    '1 Butir',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.neutral90,
                                                      fontSize: 20,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0),
                                                      child: Image.asset(
                                                        iconImages +
                                                            'clock2.png',
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    Text(
                                                      time,
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .neutral90,
                                                        fontSize: 20,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 👇 Animated SOS button
        Positioned(
          top: 180,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                iconImages + 'sos.png',
                width: 256,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
