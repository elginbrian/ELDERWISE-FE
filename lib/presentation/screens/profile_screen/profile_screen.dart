import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/bio_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool switchValue = false;
  File? _elderImage;
  File? _caregiverImage;

  Future<void> _pickImageFromGallery(bool isElder) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      setState(() {
        if (switchValue) {
          _elderImage = File(returnedImage.path);
        } else {
          _caregiverImage = File(returnedImage.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'lib/presentation/screens/assets/images/bg_floral.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 42, top: 42),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: switchValue
                                  ? (_elderImage != null
                                          ? FileImage(_elderImage!)
                                          : AssetImage(
                                              'lib/presentation/screens/assets/images/onbeard.png'))
                                      as ImageProvider
                                  : (_caregiverImage != null
                                          ? FileImage(_caregiverImage!)
                                          : AssetImage(
                                              'lib/presentation/screens/assets/images/onboard.png'))
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _pickImageFromGallery(switchValue);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.secondarySurface,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.edit,
                                color: AppColors.primaryMain,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          switchValue ? "Mbah Goro" : "Mbah Eglin",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: AppColors.neutral100,
                          ),
                        ),
                        Text(
                          switchValue ? "Caregiver" : "Elder",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: AppColors.neutral90,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.neutral20,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          AnimatedToggleSwitch<bool>.size(
                            current: switchValue,
                            values: const [false, true],
                            iconOpacity: .7,
                            indicatorSize: Size.fromHeight(100),
                            customIconBuilder: (context, local, global) => Text(
                              local.value ? 'Caregiver' : 'Elder',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: AppColors.neutral90,
                              ),
                            ),
                            borderWidth: 5,
                            iconAnimationType: AnimationType.onHover,
                            style: ToggleStyle(
                              backgroundColor: AppColors.secondarySurface,
                              indicatorColor: AppColors.primaryMain,
                              borderColor: AppColors.secondarySurface,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            selectedIconScale: 1,
                            onChanged: (value) => setState(() {
                              switchValue = value;
                            }),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          switchValue
                              ? Column(
                                  children: [
                                    BioField(
                                        title: "Nama Lengkap",
                                        content: "Andreas Bagasgoro"),
                                    BioField(
                                        title: "Tanggal Lahir",
                                        content: "04/04/2005"),
                                    BioField(
                                        title: "Jenis Kelamin", content: "Pria"),
                                    BioField(
                                        title: "Nomor Telepon",
                                        content: "082132824207"),
                                  ],
                                )
                              : Column(
                                  children: [
                                    BioField(
                                      title: "Nama Lengkap",
                                      content: "Elgin Birahi",
                                    ),
                                    BioField(
                                        title: "Tanggal Lahir",
                                        content: "04/04/2005"),
                                    BioField(
                                        title: "Jenis Kelamin",
                                        content: "Non Binary"),
                                    BioField(
                                        title: "Tinggi Badan", content: "172"),
                                    BioField(title: "Berat Badan", content: "55"),
                                  ],
                                ),
                          SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    color: AppColors.neutral90,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              openEditDialog();
                            },
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
          Positioned(
            top: 24,
            left: 0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              splashColor: Colors.transparent,
              child: Icon(Icons.keyboard_arrow_left,
                  color: AppColors.neutral10, size: 36),
            ),
          ),],
      ),
    );
  }

  Future OpenConfirmationDialog({required VoidCallback onConfirmed}) =>
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.neutral20,
              borderRadius: BorderRadius.circular(32),
            ),
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Simpan Perubahan?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: AppColors.neutral90,
                    ),
                  ),
                  SizedBox(height: 32),
                  MainButton(
                    buttonText: "Simpan",
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirmed();
                    },
                  ),
                  SizedBox(height: 16),
                  MainButton(
                    buttonText: "Batal",
                    color: AppColors.secondarySurface,
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirmed();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future openEditDialog() => showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Stack(children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.neutral20,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 32.0),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: AppColors.neutral90,
                          ),
                        ),
                      ),
                      switchValue
                          ? Column(
                              children: [
                                BioField(
                                  title: "Nama Lengkap",
                                  content: "Andreas Bagasgoro",
                                  isEditable: true,
                                ),
                                BioField(
                                  title: "Tanggal Lahir",
                                  content: "04/04/2005",
                                  isEditable: true,
                                ),
                                BioField(
                                  title: "Jenis Kelamin",
                                  content: "Pria",
                                  isEditable: true,
                                ),
                                BioField(
                                  title: "Nomor Telepon",
                                  content: "082132824207",
                                  isEditable: true,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                BioField(
                                  title: "Nama Lengkap",
                                  content: "Elgin Birahi",
                                  isEditable: true,
                                ),
                                BioField(
                                  title: "Tanggal Lahir",
                                  content: "04/04/2005",
                                  isEditable: true,
                                ),
                                BioField(
                                  title: "Jenis Kelamin",
                                  content: "Non Binary",
                                  isEditable: true,
                                ),
                                BioField(
                                  title: "Tinggi Badan",
                                  content: "172",
                                  isEditable: true,
                                ),
                                BioField(
                                  title: "Berat Badan",
                                  content: "55",
                                  isEditable: true,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 16,
                      ),
                      MainButton(
                          buttonText: "Simpan",
                          onTap: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    OpenConfirmationDialog(onConfirmed: () {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Icon(
                    Icons.cancel,
                    size: 28,
                    color: AppColors.neutral50,
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
}
