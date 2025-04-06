import 'package:elderwise/data/api/requests/auth_request.dart';
import 'package:elderwise/data/services/firebase_auth_service.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:elderwise/presentation/screens/assets/image_string.dart';
import 'package:elderwise/presentation/themes/colors.dart';
import 'package:elderwise/presentation/widgets/button.dart';
import 'package:elderwise/presentation/widgets/formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              RegisterRequestDTO(
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

    if (error.toLowerCase().contains('invalid credentials') ||
        error.toLowerCase().contains('invalid password') ||
        error.toLowerCase().contains('user not found')) {
      return 'Email atau password tidak valid. Silakan periksa kembali.';
    }

    if (error.contains('500') || error.toLowerCase().contains('server error')) {
      return 'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
    }

    if (error.toLowerCase().contains('timeout')) {
      return 'Koneksi timeout. Silakan periksa koneksi internet Anda dan coba lagi.';
    }

    if (error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('internet')) {
      return 'Terjadi masalah koneksi internet. Silakan periksa koneksi Anda dan coba lagi.';
    }

    if (error.toLowerCase().contains('not found') || error.contains('404')) {
      return 'Layanan tidak ditemukan. Silakan coba lagi nanti.';
    }

    if (error.toLowerCase().contains('unauthorized') || error.contains('401')) {
      return 'Sesi Anda telah berakhir. Silakan login kembali.';
    }

    if (error.toLowerCase().contains('forbidden') || error.contains('403')) {
      return 'Anda tidak memiliki akses ke layanan ini.';
    }

    return 'Terjadi kesalahan. Silakan coba lagi nanti.';
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _firebaseAuthService.signInWithGoogle();
      final user = userCredential.user;

      if (user != null) {
        debugPrint('Firebase Google sign in successful: ${user.email}');

        // Send the Google user data to your backend
        context.read<AuthBloc>().add(
              GoogleSignInEvent(
                GoogleAuthRequestDTO(
                  email: user.email ?? '',
                  name: user.displayName ?? '',
                  photoUrl: user.photoURL,
                  googleId: user.uid,
                  idToken: await user.getIdToken(),
                ),
              ),
            );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Google sign in failed. Please try again.',
              style: TextStyle(color: AppColors.neutral100),
            ),
            backgroundColor: AppColors.primaryMain,
          ),
        );
      }
    } catch (e) {
      debugPrint('Google sign in error: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _getFormattedErrorMessage(e.toString()),
            style: const TextStyle(color: AppColors.neutral100),
          ),
          backgroundColor: AppColors.primaryMain,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });

          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Registrasi berhasil! Silakan login.',
                  style: TextStyle(color: AppColors.neutral100),
                ),
                backgroundColor: AppColors.primaryMain,
              ),
            );
            context.go('/login');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getFormattedErrorMessage(state.error),
                    style: TextStyle(color: AppColors.neutral100)),
                backgroundColor: AppColors.primaryMain,
              ),
            );
          } else if (state is LoginSuccess) {
            // Handle successful Google sign-in/login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Login berhasil!',
                  style: TextStyle(color: AppColors.neutral100),
                ),
                backgroundColor: AppColors.primaryMain,
              ),
            );
            context.go('/home'); // Navigate to home screen
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Buat akun baru",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormField(
                          hintText: "Username",
                          icon: 'home.png',
                          controller: _usernameController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Username tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        CustomFormField(
                          hintText: "Email",
                          icon: 'home.png',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Email tidak boleh kosong'
                              : (!_isValidEmail(value)
                                  ? 'Format email tidak valid'
                                  : null),
                        ),
                        const SizedBox(height: 24),
                        CustomFormField(
                          hintText: "Password",
                          icon: 'home.png',
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Password tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 48),
                        MainButton(
                          buttonText: "Register",
                          onTap: _submitForm,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: const [
                            Expanded(
                                child: Divider(color: AppColors.neutral80)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Atau lanjutkan dengan",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            Expanded(
                                child: Divider(color: AppColors.neutral80)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: _isLoading ? null : _handleGoogleSignIn,
                          child: Container(
                            padding: const EdgeInsets.all(10),
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Sudah punya akun?",
                          style: TextStyle(
                            color: AppColors.neutral90,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: " Masuk",
                          style: TextStyle(
                            color: AppColors.primaryMain,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/login');
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
