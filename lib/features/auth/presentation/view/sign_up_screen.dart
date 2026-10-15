import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_req_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/theme.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final ApiClient apiClient;
  bool isLoading = false;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    apiClient = ApiClient();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Icon(Icons.person_add, size: 80, color: AppTheme.primary),
                const SizedBox(height: 32),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.displayLarge
                      ?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                BlocConsumer<SignupCubit, AuthState>(
                  listener: (context, state) {
                    if (state is SignupLoading) {
                      setState(() => isLoading = true);
                    }
                    if (state is SignupError) {
                      setState(() => isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    if (state is SignupSuccess) {
                      setState(() => isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign up successful'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<SignupCubit>();
                    return PrimaryButton(
                      text: 'Sign Up',
                      isLoading: isLoading,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          cubit.signup(
                            SignupReqEntity(
                              name: nameController.text,
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                          // try {
                          //   final response = await cubit.signup(
                          //     SignupReqModel(
                          //       name: nameController.text,
                          //       email: emailController.text.trim(),
                          //       password: passwordController.text.trim(),
                          //     ),
                          //   );
                          //   setState(() => isLoading = false);
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text('Sign up successful'),
                          //       backgroundColor: Colors.green,
                          //     ),
                          //   );
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const LoginScreen(),
                          //     ),
                          //   );
                          // } on DioException catch (e) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text(e.toString()),
                          //       backgroundColor: Colors.red,
                          //     ),
                          //   );
                          // }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                            ) => const LoginScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
