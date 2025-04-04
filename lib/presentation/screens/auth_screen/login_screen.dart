import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/formfield.dart';
import '../assets/image_string.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/presentation/screens/assets/images/banner.png',
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),
                          SizedBox(height: 48),
                          Column(
                            children: const [
                              Text(
                                "Selamat Datang",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                "Login menggunakan akun anda",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                Form(
                                  child: Column(
                                    children: [
                                      CustomFormField(
                                        hintText: "Username",
                                        icon: 'home.png',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 24),
                                      CustomFormField(
                                        hintText: "Password",
                                        icon: 'home.png',
                                        fontWeight: FontWeight.w600,
                                        obscureText: true,
                                      ),
                                      const SizedBox(height: 48),
                                      MainButton(
                                        buttonText: "Login",
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Expanded(
                                      child:
                                          Divider(color: AppColors.neutral80),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        "Atau lanjutkan dengan  ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                          Divider(color: AppColors.neutral80),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral10,
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 3),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(iconImages + 'google.png'),
                                ),
                                SizedBox(height: 32),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Belum punya akun?",
                                      style: TextStyle(
                                        color: AppColors.neutral90,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    TextSpan(
                                      text: " Daftar",
                                      style: TextStyle(
                                        color: AppColors.primaryMain,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 48),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
