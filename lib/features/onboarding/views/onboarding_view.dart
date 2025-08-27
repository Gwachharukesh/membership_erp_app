import 'package:flutter/material.dart';
import 'package:membership_erp_app/auth/views/signin_view.dart';
import 'package:membership_erp_app/common/constants/shared_constant.dart';
import 'package:membership_erp_app/common/constants/sizzed_box_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/paddng_constants.dart';
import '../utils/onboarding_data.dart';

class OnboardingView extends StatefulWidget {
  static const routeName = '/OnboardingView';
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentPage.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PaddingConstants.onboardingPadding,
          child: Column(
            children: [
              /// Skip button (Top-right)
              Align(
                alignment: Alignment.topRight,
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (context, value, _) {
                    return TextButton(
                      onPressed: () {
                        _pageController.jumpToPage(onboardingData.length - 1);
                      },
                      child: !(value < onboardingData.length - 1)
                          ? SizedBox()
                          : Text("Skip", style: theme.textTheme.titleSmall),
                    );
                  },
                ),
              ),

              /// Onboarding Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    _currentPage.value = index;
                  },
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: PaddingConstants.h16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.mobile_friendly, size: 120),
                          SizedBoxConstants.h30,
                          Text(
                            data["title"]!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            data["description"]!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.disabledColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Page Indicator
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, value, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: PaddingConstants.h4,
                        height: 10,
                        width: value == index ? 25 : 10,
                        decoration: BoxDecoration(
                          color: value == index
                              ? theme.primaryColor
                              : theme.disabledColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBoxConstants.h20,

              /// Next / Get Started Button
              SizedBox(
                width: 150,
                height: 50,
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (context, value, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        if (value < onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool(SharedConstant.showOnboarding, false);
                          Navigator.pushReplacementNamed(
                            context,
                            Signin.routeName,
                          );
                        }
                      },
                      child: Text(
                        value == onboardingData.length - 1
                            ? "Get Started"
                            : "Next",
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
