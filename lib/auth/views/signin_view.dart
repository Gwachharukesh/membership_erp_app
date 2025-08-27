import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:membership_erp_app/auth/repository/auth_repository.dart';
import 'package:membership_erp_app/auth/views/signup_view.dart';
import 'package:membership_erp_app/common/constants/paddng_constants.dart';
import 'package:membership_erp_app/common/constants/sizzed_box_constants.dart';
import 'package:membership_erp_app/features/dashboard/views/dashboard_navigation_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants/shared_constant.dart';
import '../../common/constants/shared_pref_initialization.dart';
import '../../common/utils/form_validation_utils.dart';
import '../view_model/auth_bloc.dart';
import '../view_model/auth_event.dart';
import '../view_model/auth_state.dart';

class Signin extends StatelessWidget {
  static const routeName = '/signin';
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    final authbloc = AuthBloc(AuthRepository());
    return BlocProvider(
      create: (context) => authbloc..add(const LoadData()),
      child: SigninView(),
    );
  }
}

class SigninView extends StatefulWidget {
  static const routeName = '/signinView';
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ValueNotifiers for reactive UI
  final ValueNotifier<bool> rememberMeNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> passwordVisibleNotifier = ValueNotifier<bool>(
    false,
  );
  // bool checkboxValueRemberMe = true;
  final ValueNotifier<bool> checkboxValuePermission = ValueNotifier(true);

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    rememberMeNotifier.dispose();
    passwordVisibleNotifier.dispose();
    checkboxValuePermission.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In", style: theme.textTheme.titleMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current.authState != previous.authState,
        listener: (context, state) {
          if (state.authState == AuthStatus.failed) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
          }

          if (state.authState == AuthStatus.success) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardNavigationHandler(),
              ),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: PaddingConstants.a16,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  "Hi, Welcome Back! 👋",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBoxConstants.h5,
                Text(
                  "Sign in to continue to your account",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBoxConstants.h30,

                // Phone field
                Text('Phone Number', style: theme.textTheme.bodySmall),
                SizedBoxConstants.h10,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) =>
                      current.username != previous.username,
                  builder: (context, state) {
                    phoneController.text = state.username;
                    return TextFormField(
                      onChanged: (value) => context.read<AuthBloc>().add(
                        OnUserNameChange(username: value),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: theme.textTheme.bodySmall,
                        filled: true,
                        fillColor: theme.disabledColor.withValues(alpha: .1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),
                SizedBoxConstants.h30,

                // Password field with ValueListenableBuilder
                Text('Password', style: theme.textTheme.bodySmall),
                SizedBoxConstants.h10,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) =>
                      current.password != previous.password,
                  builder: (context, state) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: passwordVisibleNotifier,
                      builder: (context, isVisible, _) {
                        passwordController.text = state.password;
                        return TextFormField(
                          controller: passwordController,
                          obscureText: !isVisible,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: theme.textTheme.bodySmall,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: theme.primaryColor,
                              ),
                              onPressed: () {
                                passwordVisibleNotifier.value = !isVisible;
                              },
                            ),
                            filled: true,
                            fillColor: theme.disabledColor.withValues(
                              alpha: .1,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            context.read<AuthBloc>().add(
                              OnPasswordChange(password: value),
                            );
                          },
                          validator: (value) =>
                              FormValidationUtils.formFieldValidator(
                                value: value,
                                fieldName: 'Password',
                              ),
                        );
                      },
                    );
                  },
                ),
                SizedBoxConstants.h15,

                // Remember me + Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: rememberMeNotifier,
                      builder: (context, remember, _) {
                        return Row(
                          children: [
                            Checkbox(
                              value: remember,
                              onChanged: (val) {
                                SharedPreferencesService().setBool(
                                  SharedConstant.rememberMe,
                                  value: val ?? true,
                                );
                                rememberMeNotifier.value = val ?? !remember;
                              },
                              activeColor: theme.primaryColor,
                              checkColor: theme.scaffoldBackgroundColor,
                            ),
                            Text(
                              "Remember me",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot password?",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: ValueListenableBuilder(
                        valueListenable: checkboxValuePermission,
                        builder: (context, agree, child) {
                          return Checkbox(
                            value: agree,
                            onChanged: (value) {
                              checkboxValuePermission.value = value ?? !agree;
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // try{
                          launchUrl(
                            Uri.parse('https://dynamic.net.np/privacy-policy'),
                          );
                          // }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By checking this box, you agree to our Privacy Policy.',
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.visible,
                            ),
                            // Text(
                            //   "https://www.dynamic.net.np/privacy-policy",
                            //   style: DynamicTheme.blue10pxmedium,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBoxConstants.h30,

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<AuthBloc>().add(SigninUser());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: theme.scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: (state.authState == AuthStatus.loading)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Sign In",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ),
                SizedBoxConstants.h20,
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Create",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Sign Up screen
                              Navigator.pushNamed(
                                context,
                                SignupView.routeName,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
