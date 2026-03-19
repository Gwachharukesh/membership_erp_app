import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mart_erp/auth/views/signin_view.dart';
import 'package:mart_erp/common/constants/color_manager.dart';
import 'package:mart_erp/common/models/flavor_env_data.dart';
import 'package:mart_erp/common/services/baseurl_service.dart';
import 'package:mart_erp/features/one_time_setup/model/company_domain_detail/company_domain_detail.dart';
import 'package:mart_erp/features/one_time_setup/model/domainrequestmodel.dart';
import 'package:mart_erp/features/one_time_setup/service/onetime_setup_service.dart';

class OneTimeSetUpScreen extends StatefulWidget {
  const OneTimeSetUpScreen({super.key});
  static const routeName = '/Onetimesetup';

  @override
  OneTimeSetUpScreenState createState() => OneTimeSetUpScreenState();
}

// String pattern =
//     r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
// RegExp regExp = RegExp(pattern);

class OneTimeSetUpScreenState extends State<OneTimeSetUpScreen>
    with TickerProviderStateMixin {
  TextEditingController inputController = TextEditingController();
  final _codeKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    inputController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  Dio dio = Dio();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorManager.dvBlueAccent.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
                ColorManager.primary.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(flex: 2, child: _TopPortion()),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        children: [
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 800),
                            child: Text(
                              'Welcome',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.primary,
                                    shadows: [
                                      Shadow(
                                        color: ColorManager.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 1000),
                            child: Text(
                              'Set Up Your Company',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 600),
                            child: _buildFormCard(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Form(
        key: _codeKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[200]!.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: inputController,
                // inputFormatters: const [
                //   // FilteringTextInputFormatter.digitsOnly,
                //   // FilteringTextInputFormatter.deny(RegExp(r'\s')),
                // ],
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Company Code / Url',
                  hintText: 'Enter to config ',
                  labelStyle: TextStyle(
                    color: ColorManager.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.change_circle,
                      size: 5.w,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      inputController.clear();
                    },
                  ),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(1.5.w),
                    child: Icon(
                      Icons.code,
                      color: ColorManager.primary,
                      size: 5.w,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 2.h,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: ColorManager.primary.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid company code';
                  }
                  if (value.length < 3) {
                    return 'Company code must be at least 3 digits';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              height: 5.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ColorManager.primary, ColorManager.dvBlueAccent],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onContinueButtonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 3.h,
                        width: 3.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(Icons.arrow_forward_rounded, size: 5.w),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onContinueButtonTap() async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    if (!_codeKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (inputController.text == '1234') {
      final FlavorEnvData flavorData = FlavorEnvData(
        companyName: 'Dynamic Sales Fusion',
        dateFormat: 'ad',
        logoPath: '',
        baseUrl: 'https://dvtrading.com.np',
        address: 'Kathmandu Nepal',
        dbCode: '',
      );

      await BaseurlService.updateBaseUrl('https://dvtrading.com.np');

      await FlavorEnvData.addToPreferences(flavorData);

      if (mounted) {
        await Navigator.pushReplacementNamed(context, Signin.routeName);
      }
      return;
    }

    try {
      final text = inputController.text.trim();
      final isCode = text.contains('https') || text.contains('http')
          ? false
          : true;

      final CompanyDomainDetail? response = await OneTimeSetup.getDomainDetail(
        isCode
            ? Domainrequestmodel(companyCode: inputController.text)
            : Domainrequestmodel(urlName: inputController.text),
      );

      final bool validResponse = response?.companyCode == inputController.text;

      if (response != null && (response.isSuccess == true) && validResponse) {
        //pivotal_
        final dbCode = (response.dbName != null && response.dbName!.isNotEmpty)
            ? response.dbName!.contains('pivotal_')
                  ? response.dbName
                  : 'pivotal_${response.dbName}_v1'
            : 'pivotal_${inputController.text}_v1';
        final baseUrl =
            response.urlName != null && response.urlName?.isNotEmpty == true
            ? 'https://${response.urlName}'
            : 'https://admin.salesfusion.online';

        final FlavorEnvData flavorData = FlavorEnvData(
          companyName: response.companyName ?? '',
          dateFormat: 'ad',
          logoPath: response.logopath ?? '',
          address: response.fullAddress ?? '',
          dbCode: dbCode,
          baseUrl: baseUrl,
        );

        await FlavorEnvData.addToPreferences(flavorData);

        await BaseurlService.updateBaseUrl(baseUrl);

        if (mounted) {
          Navigator.pushReplacementNamed(context, Signin.routeName);
        }
      } else {
        // Add error haptic feedback
      }
    } catch (e) {
      debugPrint(e.toString());
      // Add error haptic feedback
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _TopPortion extends StatefulWidget {
  const _TopPortion();

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion>
    with TickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late AnimationController _shimmerAnimationController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Shimmer animation
    _shimmerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shimmerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _shimmerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background with animated gradient
        AnimatedBuilder(
          animation: _iconAnimationController,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.only(bottom: 5.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorManager.primary.withValues(alpha: 0.9),
                    ColorManager.dvBlueAccent.withValues(alpha: 0.8),
                    ColorManager.primary.withValues(alpha: 0.7),
                  ],
                  stops: [0.0, 0.5 + 0.1 * _iconAnimationController.value, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.h),
                  bottomRight: Radius.circular(8.h),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            );
          },
        ),
        // Shimmer overlay effect
        AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.only(bottom: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.h),
                  bottomRight: Radius.circular(8.h),
                ),
                gradient: LinearGradient(
                  begin: Alignment(_shimmerAnimation.value - 0.5, -0.5),
                  end: Alignment(_shimmerAnimation.value + 0.5, 0.5),
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),
        // Floating particles effect
        ...List.generate(5, (index) {
          return Positioned(
            left: (index * 20.w) % 80.w,
            top: (index * 15.h) % 40.h,
            child: AnimatedBuilder(
              animation: _iconAnimationController,
              builder: (context, child) {
                return Opacity(
                  opacity:
                      0.1 +
                      0.1 * ((index + _iconAnimationController.value * 2) % 1),
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          );
        }),
        // Main icon with animations
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedBuilder(
            animation: _iconAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _iconScaleAnimation.value,
                child: Transform.rotate(
                  angle: _iconRotationAnimation.value,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: ColorManager.primary.withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/logo/dynamicSalesFusion.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
