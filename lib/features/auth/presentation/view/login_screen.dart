import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/signup_datasource_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repositories/signup_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/signup_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../main_navigation/screens/main_navigation_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool isLoading = false;
  late final ApiClient apiClient;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    apiClient = ApiClient();
    super.initState();
  }

  @override
  void dispose() {
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
                const SizedBox(height: 60),
                Icon(Icons.shopping_bag, size: 80, color: AppTheme.primary),
                const SizedBox(height: 32),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.displayLarge
                      ?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to continue your shopping',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
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
                BlocConsumer<LoginCubit, AuthState>(
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      isLoading = true;
                    }
                    if (state is LoginError) {
                      isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    if (state is LoginSuccess) {
                      isLoading = false;
                      if (!mounted) return;

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MainNavigationScreen(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final loginCubit = context.read<LoginCubit>();
                    return PrimaryButton(
                      text: 'Login',
                      isLoading: isLoading,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          loginCubit.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          // setState(() => isLoading = true);
                          // try {
                          //   final response = await loginService.login(
                          //     email: emailController.text.trim(),
                          //     password: passwordController.text.trim(),
                          //   );
                          //   debugPrint("Access Token: ${response.accessToken} ");
                          //   debugPrint("Refresh Token: ${response.refreshToken} ");
                          //   setState(() => isLoading = false);
                          //   if (!mounted) return;
                          //   Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //       builder: (context) => MainNavigationScreen(),
                          //     ),
                          //   );
                          // } on DioException catch (e) {
                          //   setState(() => isLoading = false);
                          //   if (!mounted) return;
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
                    const Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BlocProvider(
                                      create: (context) => SignupCubit(
                                        SignupUsecase(
                                          SignupRepoImp(
                                            SignupDatasourceImp(ApiClient()),
                                          ),
                                        ),
                                      ),
                                      child: const SignUpScreen(),
                                    ),
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
  }
}
