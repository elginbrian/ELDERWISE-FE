import 'package:elderwise/data/api/requests/auth_request.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../widgets/formfield.dart';
import '../assets/image_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginEvent(
              LoginRequestDTO(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            ),
          );
    }
  }

  bool _isConnectionError(String errorMessage) {
    return errorMessage.contains('connection error') ||
        errorMessage.contains('XMLHttpRequest') ||
        errorMessage.contains('network');
  }

  String _getFormattedErrorMessage(String error) {
    if (kIsWeb && _isConnectionError(error)) {
      return 'Koneksi gagal. Hal ini mungkin disebabkan oleh masalah CORS.';
    }
    return error;
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);

          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login berhasil!',
                    style: TextStyle(color: AppColors.neutral100)),
                backgroundColor: AppColors.primaryMain,
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getFormattedErrorMessage(state.error),
                    style: const TextStyle(color: AppColors.neutral100)),
                backgroundColor: AppColors.primaryMain,
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/presentation/screens/assets/images/banner.png',
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 48),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomFormField(
                                hintText: "Email",
                                icon: 'home.png',
                                fontWeight: FontWeight.w600,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!_isValidEmail(value)) {
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              CustomFormField(
                                hintText: "Password",
                                icon: 'home.png',
                                fontWeight: FontWeight.w600,
                                obscureText: true,
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 48),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  MainButton(
                                    buttonText: "Login",
                                    onTap: _submitForm,
                                    isLoading: _isLoading,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: Divider(color: AppColors.neutral80),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Atau lanjutkan dengan  ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: AppColors.neutral80),
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
                          child: Image.asset('${iconImages}google.png'),
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
                              recognizer: TapGestureRecognizer()..onTap = () {},
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
        ),
      ),
    );
  }
}
