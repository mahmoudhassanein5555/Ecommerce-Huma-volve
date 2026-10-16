import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/network%20services/network_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/data_source/;ogin_datasource_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/data_source/login_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/repository/login_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/repository/login_repo.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/usecase/login_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/presentation/screens/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/presentation/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/theme.dart';

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
  bool isLoading = false;
  late final LoginCubit loginCubit;
  late final LoginRepository loginRepo;
  late final LoginUseCase loginUseCase;
  late final NetworkServices networkServices;
  late final LoginDatasource loginDataSource;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    networkServices = NetworkServices();
    loginDataSource = LoginDataSourceImp(networkServices);
    loginRepo = LoginRepoImp(loginDataSource);
    loginUseCase = LoginUseCase(loginRepo);
    loginCubit = LoginCubit(loginUseCase);
  }

  void signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      try {
        final signupService = context.read<SignupCubit>();
        await signupService.signup(
          SignupReqModel(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Account created successfully!'),
          ),
        );
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<LoginCubit>.value(
              value: loginCubit,
              child: const LoginScreen(),
            ),
          ),
        );
      } on DioException catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${e.toString()} An error occurred. Please try again.',
            ),
          ),
        );
      }
    }
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
                PrimaryButton(
                  isLoading: isLoading,
                  text: 'Sign Up',
                  onPressed: signUp,
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BlocProvider<LoginCubit>.value(
                                      value: loginCubit,
                                      child: const LoginScreen(),
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