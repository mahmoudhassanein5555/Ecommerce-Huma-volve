import 'package:ecommerce_app_huma_volve/core/di/injection.dart';
import 'package:ecommerce_app_huma_volve/core/routing/navigation.dart';
import 'package:ecommerce_app_huma_volve/core/routing/routes.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/theme.dart';
import '../../../login/ui/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // final _formKey = GlobalKey<FormState>();
  // late final TextEditingController nameController;
  // late final TextEditingController emailController;
  // late final TextEditingController passwordController;

  // @override
  // void initState() {
  // nameController = TextEditingController();
  // emailController = TextEditingController();
  // passwordController = TextEditingController();

  //   super.initState();
  // }

  // @override
  // void dispose() {
  // nameController.dispose();
  // emailController.dispose();
  // passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return
    // BlocProvider(
    //   create: (context) => getIt<SignUpCubit>(),
    //   child:
    BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
        if (state is SignUpSuccess) {
          context.pushReplacementNamed(Routes.login);
          // context.pushReplacementNamed(Routes.mainScreen);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => const LoginScreen()),
          // );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: context.read<SignUpCubit>().formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Icon(Icons.person_add, size: 80, color: AppTheme.primary),
                    const SizedBox(height: 32),
                    Text(
                      'Create Account',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    CustomTextField(
                      controller: context.read<SignUpCubit>().nameController,
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
                      controller: context.read<SignUpCubit>().emailController,
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
                      controller:
                          context.read<SignUpCubit>().passwordController,
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
                    PrimaryButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        context.read<SignUpCubit>().signup();
                        // if (_formKey.currentState?.validate() ?? false) {
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const LoginScreen(),
                        //     ),
                        //   );
                        // }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () {
                            context.pushReplacementNamed(Routes.login);
                            // Navigator.pushReplacement(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder:
                            //         (context, animation, secondaryAnimation) =>
                            //             const LoginScreen(),
                            //     transitionsBuilder: (
                            //       context,
                            //       animation,
                            //       secondaryAnimation,
                            //       child,
                            //     ) {
                            //       return FadeTransition(
                            //         opacity: animation,
                            //         child: child,
                            //       );
                            //     },
                            //   ),
                            // );
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
      },
      //  ),
    );
  }
}
