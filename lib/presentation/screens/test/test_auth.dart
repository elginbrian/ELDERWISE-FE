import 'package:elderwise/di/container.dart';
import 'package:elderwise/data/api/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elderwise/data/api/requests/auth_request.dart';
import 'package:elderwise/presentation/bloc/auth/auth_bloc.dart';
import 'package:elderwise/presentation/bloc/auth/auth_event.dart';
import 'package:elderwise/presentation/bloc/auth/auth_state.dart';
import 'package:get_it/get_it.dart';

class TestAuthScreen extends StatefulWidget {
  const TestAuthScreen({Key? key}) : super(key: key);

  @override
  _TestAuthScreenState createState() => _TestAuthScreenState();
}

class _TestAuthScreenState extends State<TestAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = true;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _ensureInitialization();
  }

  Future<void> _ensureInitialization() async {
    setState(() {
      _isLoading = true;
      _initError = null;
    });

    try {
      await appConfig.initialize();

      if (!GetIt.instance.isRegistered<AuthBloc>()) {
        setupDependencies();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error during initialization: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initError = "Initialization error: $e";
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  LoginRequestDTO _buildLoginRequest() {
    return LoginRequestDTO(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  RegisterRequestDTO _buildRegisterRequest() {
    return RegisterRequestDTO(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Auth")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _initError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error initializing dependencies',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(_initError!,
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _ensureInitialization,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocProvider<AuthBloc>(
      create: (_) {
        try {
          return getIt<AuthBloc>();
        } catch (e) {
          print('Error creating AuthBloc: $e');
          throw Exception('Could not initialize AuthBloc: $e');
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Authentication Credentials',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Actions',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<AuthBloc>()
                                .add(LoginEvent(_buildLoginRequest()));
                          },
                          child: const Text("Login"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<AuthBloc>()
                                .add(RegisterEvent(_buildRegisterRequest()));
                          },
                          child: const Text("Register"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LoginSuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Login Success',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          _buildDetailRow(
                              'Response', state.response.toString()),
                        ],
                      ),
                    ),
                  );
                } else if (state is RegisterSuccess) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register Success',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          _buildDetailRow(
                              'Response', state.response.toString()),
                        ],
                      ),
                    ),
                  );
                } else if (state is AuthFailure) {
                  return Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Authentication Error:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.error,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Enter credentials and press a button to login or register',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
