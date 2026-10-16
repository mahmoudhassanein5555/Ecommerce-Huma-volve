import 'package:ecommerce_app_huma_volve/core/imports/common_imports.dart'
    hide State;
import 'package:ecommerce_app_huma_volve/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
        if (state is LoginSuccess) {
          context.go(Routes.mainScreen);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: context.read<LoginCubit>().formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    Icon(Icons.shopping_bag, size: 80, color: AppTheme.primary),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome Back!',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to continue your shopping',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 64),
                    CustomTextField(
                      controller: context.read<LoginCubit>().emailController,
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
                      controller: context.read<LoginCubit>().passwordController,
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
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Login',
                      onPressed: () {
                        context.read<LoginCubit>().login();
                        // if (_formKey.currentState?.validate() ?? false) {
                        //   Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(
                        //       builder: (context) => MainNavigationScreen(),
                        //     ),
                        //   );
                        // }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account? '),
                        GestureDetector(
                          onTap: () {
                            context.go(Routes.signup);
                            // Navigator.pushReplacement(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder:
                            //         (
                            //           context,
                            //           animation,
                            //           secondaryAnimation,
                            //         ) => const SignUpScreen(),
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
                            'Sign Up',
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
      //   ),
    );
  }
}
