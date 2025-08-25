import 'package:flutter/material.dart';
import 'package:membership_erp_app/common/constants/paddng_constants.dart';
import 'package:membership_erp_app/common/constants/sizzed_box_constants.dart';

class SignupView extends StatefulWidget {
  static const routeName = '/signupView';
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final ValueNotifier<bool> passwordVisibleNotifier = ValueNotifier<bool>(
    false,
  );

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    passwordVisibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: theme.textTheme.titleMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: PaddingConstants.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Create New Account 🔥",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBoxConstants.h5,
            Text(
              "Please fill your detail information",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBoxConstants.h30,

            // Full Name
            Text("Full Name", style: theme.textTheme.bodySmall),
            SizedBoxConstants.h10,
            TextField(
              controller: fullNameController,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: "Full Name",
                filled: true,
                fillColor: theme.disabledColor.withValues(alpha: .1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBoxConstants.h20,

            // Email
            Text("Email", style: theme.textTheme.bodySmall),
            SizedBoxConstants.h10,
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: "Email",
                filled: true,
                fillColor: theme.disabledColor.withValues(alpha: .1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBoxConstants.h20,

            // Password
            Text("Password", style: theme.textTheme.bodySmall),
            SizedBoxConstants.h10,
            ValueListenableBuilder<bool>(
              valueListenable: passwordVisibleNotifier,
              builder: (context, isVisible, _) {
                return TextField(
                  controller: passwordController,
                  obscureText: !isVisible,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: theme.disabledColor.withValues(alpha: .1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: theme.primaryColor,
                      ),
                      onPressed: () {
                        passwordVisibleNotifier.value = !isVisible;
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBoxConstants.h20,

            // Confirm Password
            Text("Confirm Password", style: theme.textTheme.bodySmall),
            SizedBoxConstants.h10,
            ValueListenableBuilder<bool>(
              valueListenable: passwordVisibleNotifier,
              builder: (context, isVisible, _) {
                return TextField(
                  controller: confirmController,
                  obscureText: !isVisible,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    filled: true,
                    fillColor: theme.disabledColor.withValues(alpha: .1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: theme.primaryColor,
                      ),
                      onPressed: () {
                        passwordVisibleNotifier.value = !isVisible;
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBoxConstants.h30,

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Implement sign up logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text("Sign Up", style: theme.textTheme.titleSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
