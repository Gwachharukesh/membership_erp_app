import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mart_erp/auth/models/token_models.dart';
import 'package:mart_erp/auth/repository/auth_repository.dart';
import 'package:mart_erp/common/constants/shared_constant.dart';
import 'package:mart_erp/common/constants/shared_pref_initialization.dart';
import 'package:mart_erp/common/utils/form_validation_utils.dart';
import 'package:mart_erp/features/customer/screen/add_customer.dart';
import 'package:mart_erp/features/dashboard/views/dashboard_navigation_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view_model/auth_bloc.dart';
import '../view_model/auth_event.dart';
import '../view_model/auth_state.dart';

class Signin extends StatelessWidget {
  static const routeName = '/signin';
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return const SigninView();
  }
}

class SigninView extends StatefulWidget {
  static const routeName = '/signinView';
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passVisible = ValueNotifier(false);
  final _remember = ValueNotifier(true);
  final _agreePolicy = ValueNotifier(true);
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _passVisible.dispose();
    _remember.dispose();
    _agreePolicy.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<TokenModel?> _getAdminToken() async {
    return AuthRepository().signin(
      username: 'admin',
      password: 'Demo1@#123',
      isForMasterToken: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) => c.authState != p.authState,
          listener: (context, state) {
            if (state.authState == AuthStatus.failed) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? 'Login failed'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
            }
            if (state.authState == AuthStatus.success) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const DashboardNavigationHandler(),
                ),
                (r) => false,
              );
            }
          },
          child: SizedBox.expand(
            child: Stack(
              children: [
                // Gradient header background
                Container(
                  width: screenW,
                  height: screenH * 0.38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.primary,
                        colors.primary.withValues(alpha: 0.85),
                        colors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              size: 34,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Mart ERP',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your smart shopping companion',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // Form card
                Positioned.fill(
                  top: screenH * 0.30,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: colors.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sign in to continue to your account',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // Phone
                                _FieldLabel(label: 'Phone Number'),
                                const SizedBox(height: 8),
                                BlocBuilder<AuthBloc, AuthState>(
                                  buildWhen: (p, c) => c.username != p.username,
                                  builder: (ctx, state) {
                                    _phoneCtrl.text = state.username;
                                    return _buildField(
                                      controller: _phoneCtrl,
                                      hint: 'Enter your phone number',
                                      icon: Icons.phone_outlined,
                                      keyboard: TextInputType.phone,
                                      formatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onChanged: (v) => ctx
                                          .read<AuthBloc>()
                                          .add(OnUserNameChange(username: v)),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Phone number is required'
                                          : null,
                                    );
                                  },
                                ),

                                const SizedBox(height: 20),

                                // Password
                                _FieldLabel(label: 'Password'),
                                const SizedBox(height: 8),
                                BlocBuilder<AuthBloc, AuthState>(
                                  buildWhen: (p, c) => c.password != p.password,
                                  builder: (ctx, state) {
                                    _passCtrl.text = state.password;
                                    return ValueListenableBuilder<bool>(
                                      valueListenable: _passVisible,
                                      builder: (_, vis, __) => _buildField(
                                        controller: _passCtrl,
                                        hint: 'Enter your password',
                                        icon: Icons.lock_outline_rounded,
                                        obscure: !vis,
                                        suffix: _VisToggle(
                                          visible: vis,
                                          onTap: () =>
                                              _passVisible.value = !vis,
                                        ),
                                        onChanged: (v) => ctx
                                            .read<AuthBloc>()
                                            .add(OnPasswordChange(password: v)),
                                        validator: (v) =>
                                            FormValidationUtils.formFieldValidator(
                                              value: v,
                                              fieldName: 'Password',
                                            ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Remember + Forgot
                                Row(
                                  children: [
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _remember,
                                      builder: (_, val, __) => GestureDetector(
                                        onTap: () {
                                          _remember.value = !val;
                                          SharedPreferencesService().setBool(
                                            SharedConstant.rememberMe,
                                            value: !val,
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: val
                                                    ? colors.primary
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: val
                                                      ? colors.primary
                                                      : colors.outline
                                                            .withValues(
                                                              alpha: 0.4,
                                                            ),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: val
                                                  ? const Icon(
                                                      Icons.check_rounded,
                                                      size: 14,
                                                      color: Colors.white,
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Remember me',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: colors.onSurface
                                                        .withValues(
                                                          alpha: 0.65,
                                                        ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Forgot Password?',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: colors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Policy
                                ValueListenableBuilder<bool>(
                                  valueListenable: _agreePolicy,
                                  builder: (_, val, __) => GestureDetector(
                                    onTap: () => _agreePolicy.value = !val,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.only(top: 1),
                                          decoration: BoxDecoration(
                                            color: val
                                                ? colors.primary
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            border: Border.all(
                                              color: val
                                                  ? colors.primary
                                                  : colors.outline.withValues(
                                                      alpha: 0.4,
                                                    ),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: val
                                              ? const Icon(
                                                  Icons.check_rounded,
                                                  size: 14,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'I agree to the ',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: colors.onSurface
                                                        .withValues(
                                                          alpha: 0.55,
                                                        ),
                                                    height: 1.5,
                                                  ),
                                              children: [
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: TextStyle(
                                                    color: colors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => launchUrl(
                                                      Uri.parse(
                                                        'https://dynamic.net.np/privacy-policy',
                                                      ),
                                                    ),
                                                ),
                                                const TextSpan(text: ' and '),
                                                TextSpan(
                                                  text: 'Terms of Service',
                                                  style: TextStyle(
                                                    color: colors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // Sign In CTA
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (ctx, state) {
                                    final loading =
                                        state.authState == AuthStatus.loading;
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: FilledButton(
                                        onPressed: loading
                                            ? null
                                            : () {
                                                if (_formKey.currentState
                                                        ?.validate() ??
                                                    false) {
                                                  ctx.read<AuthBloc>().add(
                                                    SigninUser(),
                                                  );
                                                }
                                              },
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: loading
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : Text(
                                                'Sign In',
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                    ),
                                              ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Or divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: colors.outline.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        'OR',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: colors.onSurface
                                                  .withValues(alpha: 0.35),
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: colors.outline.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Create account button
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final uniqueId = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                      EasyLoading.show(
                                        status: 'Please wait...',
                                      );
                                      final token = await _getAdminToken();
                                      EasyLoading.dismiss();
                                      if (token == null) {
                                        EasyLoading.showError(
                                          'Registration currently unavailable.\nPlease contact admin.',
                                        );
                                        return;
                                      }
                                      if (!mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddCustomerScreen(
                                            uniqueId: uniqueId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      side: BorderSide(
                                        color: colors.primary.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Create New Account',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colors.primary,
                                            letterSpacing: 0.3,
                                          ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    bool obscure = false,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: formatters,
      obscureText: obscure,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colors.onSurface.withValues(alpha: 0.35),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(
            icon,
            size: 20,
            color: colors.primary.withValues(alpha: 0.7),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        suffixIcon: suffix,
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.35),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
      ),
    );
  }
}

class _VisToggle extends StatelessWidget {
  const _VisToggle({required this.visible, required this.onTap});
  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        visible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
        size: 20,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}
