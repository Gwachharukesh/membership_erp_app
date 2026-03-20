import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mart_erp/auth/views/signin_view.dart';
import 'package:mart_erp/common/utils/image_file_picker_utils.dart';
import 'package:mart_erp/common/utils/location_utils.dart';
import 'package:mart_erp/common/widgets/date_picker_widget.dart';
import 'package:mart_erp/features/customer/add_customer_model.dart';
import 'package:mart_erp/features/customer/bloc/add_customer_bloc.dart';
import 'package:mart_erp/features/customer/bloc/add_customer_event.dart';
import 'package:mart_erp/features/customer/bloc/add_customer_state.dart';
import 'package:mart_erp/features/customer/widget/customer_creation_error.dart';
import 'package:mart_erp/features/customer/widget/process_starte_widget.dart';
import 'package:mart_erp/otp/model/otp_genetate_model.dart';
import 'package:mart_erp/otp/screen/otp_verification_screen.dart';
import 'package:mart_erp/otp/service/otp_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({required this.uniqueId, super.key});
  final String uniqueId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddCustomerBloc(),
      child: AddCustomerView(uniqueId: uniqueId),
    );
  }
}

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({required this.uniqueId, super.key});
  final String uniqueId;

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _panCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _latCtrl = TextEditingController(text: '0');
  final _lonCtrl = TextEditingController(text: '0');
  final _landmarkCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLocation();
      if (kDebugMode) _fillDemo();
    });
  }

  void _fillDemo() {
    _nameCtrl.text = 'Demo Customer';
    _mobileCtrl.text = '9841234567';
    _emailCtrl.text = 'rukesh.gwachha@dynamic.net.np';
    _panCtrl.text = '123456789';
    _addressCtrl.text = 'Demo Address, Kathmandu, Nepal';
    _landmarkCtrl.text = 'Demo Location';
    _dobCtrl.text = '1990-01-01';
  }

  Future<void> _fetchLocation() async {
    try {
      final pos = await LocationUtils.getUserCurrentLocation();
      if (mounted) {
        _latCtrl.text = pos?.latitude.toStringAsFixed(6) ?? '0';
        _lonCtrl.text = pos?.longitude.toStringAsFixed(6) ?? '0';
        context.read<AddCustomerBloc>().add(const AddCustomerSetReady());
      }
    } catch (e) {
      debugPrint('Location error: $e');
      if (mounted) {
        context.read<AddCustomerBloc>().add(const AddCustomerSetReady());
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _panCtrl.dispose();
    _addressCtrl.dispose();
    _latCtrl.dispose();
    _lonCtrl.dispose();
    _landmarkCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_latCtrl.text == '0') {
      EasyLoading.showError('Please enable location services');
      return;
    }

    try {
      EasyLoading.show(status: 'Registering...');

      var customer = AddCustomerModel(
        uniqueId: widget.uniqueId,
        name: _nameCtrl.text.trim(),
        mobileNo: _mobileCtrl.text.trim(),
        emailId: _emailCtrl.text.trim(),
        panVatNo: _panCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        lat: _latCtrl.text,
        lon: _lonCtrl.text,
        location: _landmarkCtrl.text.trim(),
        dob: _dobCtrl.text,
      );

      final state = context.read<AddCustomerBloc>().state;
      if (state.pickedImages.isNotEmpty) {
        customer = customer.copyWith(
          image: state.pickedImages.last.path,
          imagePath: state.pickedImages.last.path,
        );
      }

      final otpRequest = OtpGenerateModel(
        emailId: customer.emailId ?? '',
        hashData: customer.tokenhashData,
        mobileNo: customer.mobileNo,
        uniqueId: widget.uniqueId,
        addCustomerModel: customer,
        refId: widget.uniqueId,
      );

      final data = await OtpService.generateOtp(otpData: otpRequest);
      if (mounted) EasyLoading.dismiss();

      if (data.isSuccess ?? false) {
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationScreen(
              otpGenetateData: otpRequest,
              onVerificationSuccess: () async {
                _reset();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Signin()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        );
      } else {
        EasyLoading.showError(data.responseMsg ?? 'Registration failed');
        _reset();
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ErrorScreen()),
        );
      }
    }
  }

  void _reset() {
    _nameCtrl.clear();
    _mobileCtrl.clear();
    _emailCtrl.clear();
    _panCtrl.clear();
    _addressCtrl.clear();
    _latCtrl.text = '0';
    _lonCtrl.text = '0';
    _landmarkCtrl.clear();
    _dobCtrl.clear();
    context.read<AddCustomerBloc>().add(const AddCustomerImagesCleared());
    context.read<AddCustomerBloc>().add(const AddCustomerReset());
    _formKey.currentState?.reset();
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.camera.request();
      if (status.isDenied) {
        EasyLoading.showError('Camera permission required');
        return;
      }
      final image = await ImageFilePickerUtils.getImageOnly(context: context);
      if (image != null && mounted) {
        context.read<AddCustomerBloc>().add(AddCustomerImagePicked(image));
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          style: IconButton.styleFrom(
            backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        title: Text(
          'Create Account',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Step 1/3',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AddCustomerBloc, AddCustomerState>(
        builder: (context, customerState) {
          return CustomerProcessingWidget(
            onRetry: () =>
                context.read<AddCustomerBloc>().add(const AddCustomerReset()),
            message: customerState.errorMessage ?? '',
            navigate: () {},
            customerstate: customerState,
            readyContent: Column(
              children: [
                // Progress bar
                _ProgressBar(value: 0.33),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Avatar ─────────────────────────────────
                          _AvatarPicker(
                            state: customerState,
                            onPick: _pickImage,
                          ),
                          const SizedBox(height: 28),

                          // ── Section: Personal Info ─────────────────
                          _SectionTitle(title: 'Personal Information'),
                          const SizedBox(height: 16),

                          _Field(
                            controller: _nameCtrl,
                            label: 'Full Name',
                            hint: 'e.g. Sagar Sharma',
                            prefixIcon: Icons.person_outline_rounded,
                            textCapitalization: TextCapitalization.words,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Name is required'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _mobileCtrl,
                            label: 'Mobile Number',
                            hint: 'e.g. 98XXXXXXXX',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Mobile number is required';
                              }
                              if (v.length != 10) {
                                return 'Enter a valid 10-digit number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _dobCtrl,
                            label: 'Date of Birth',
                            hint: 'Select date',
                            prefixIcon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: () async {
                              final date =
                                  await DateAndTimePicker.showCustomDatePicker(
                                context,
                                lastDate: DateTime.now(),
                              );
                              if (date != null) _dobCtrl.text = date.format();
                            },
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Date of birth is required'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _emailCtrl,
                            label: 'Email Address',
                            hint: 'e.g. name@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(v)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 28),

                          // ── Section: Additional Details ────────────
                          _SectionTitle(title: 'Additional Details'),
                          const SizedBox(height: 16),

                          _Field(
                            controller: _panCtrl,
                            label: 'PAN / VAT Number',
                            hint: 'Optional — 9 digits',
                            prefixIcon: Icons.credit_card_outlined,
                            formatters: [LengthLimitingTextInputFormatter(9)],
                            validator: (v) {
                              if (v != null && v.isNotEmpty && v.length != 9) {
                                return 'Enter a valid 9-digit PAN';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _addressCtrl,
                            label: 'Full Address',
                            hint: 'e.g. Kathmandu, Nepal',
                            prefixIcon: Icons.home_outlined,
                            maxLines: 2,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Address is required'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _landmarkCtrl,
                            label: 'Nearest Landmark',
                            hint: 'Optional — nearby landmark',
                            prefixIcon: Icons.location_on_outlined,
                          ),

                          const SizedBox(height: 32),

                          // ── Submit ─────────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: _submit,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Continue',
                                    style:
                                        theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Sign in link ───────────────────────────
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Already have an account? ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.5),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Progress Bar ────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 3,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Avatar Picker ───────────────────────────────────────────────────────────

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.state, required this.onPick});
  final AddCustomerState state;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasImage = state.pickedImages.isNotEmpty;

    return Center(
      child: GestureDetector(
        onTap: onPick,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.surfaceContainerHighest,
                    border: Border.all(
                      color: cs.primary.withValues(alpha: 0.25),
                      width: 2.5,
                    ),
                    image: hasImage
                        ? DecorationImage(
                            image: FileImage(state.pickedImages.last),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !hasImage
                      ? Icon(
                          Icons.person_rounded,
                          size: 40,
                          color: cs.onSurface.withValues(alpha: 0.25),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: -2,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary,
                      border: Border.all(color: cs.surface, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              hasImage ? 'Change photo' : 'Add profile photo',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Title ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

// ─── Field ───────────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.hint,
    this.keyboardType,
    this.formatters,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      validator: validator,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.55),
          fontWeight: FontWeight.w500,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.3),
        ),
        floatingLabelStyle: theme.textTheme.bodySmall?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(prefixIcon, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
      ),
    );
  }
}
