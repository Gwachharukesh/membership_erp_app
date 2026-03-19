import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/auth/views/signin_view.dart';
import 'package:mart_erp/otp/model/otp_genetate_model.dart';
import 'package:pinput/pinput.dart';

import '../model/otp_bloc.dart';
import '../model/otp_event.dart';
import '../model/otp_state.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({
    required this.otpGenetateData,
    super.key,
    this.onVerificationSuccess,
  });

  final OtpGenerateModel otpGenetateData;
  final VoidCallback? onVerificationSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpBloc(otpGenerateData: otpGenetateData),
      child: const _OTPVerificationView(),
    );
  }
}

class _OTPVerificationView extends StatelessWidget {
  const _OTPVerificationView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: (context, state) {
        // Handle success state
        if (state.status == OtpStatus.customerCreationSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        // Handle failure state
        if (state.status == OtpStatus.customerCreationFailed) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 70, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Customer Registration Failed',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.errorMessage ?? 'Please try again later',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        // Loading state during customer creation
        if (state.status == OtpStatus.otpVerified &&
            state.status != OtpStatus.customerCreationSuccess) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LottieAnimatedWidget.creatingCustomer(),
                  const SizedBox(height: 20),
                  const Text('Creating your account...'),
                ],
              ),
            ),
          );
        }

        return _OTPInputView(
          otpGenetateData: context.read<OtpBloc>().otpGenerateData,
        );
      },
    );
  }
}

class _OTPInputView extends StatelessWidget {
  const _OTPInputView({required this.otpGenetateData});

  final OtpGenerateModel otpGenetateData;

  @override
  Widget build(BuildContext context) {
    final otpBloc = context.read<OtpBloc>();
    final state = context.watch<OtpBloc>().state;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 40),
                Text(
                  'Verify Your Identity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ve sent a 6-digit code to',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  otpGenetateData.emailId ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Pinput(
                    length: 6,
                    onChanged: (value) => otpBloc.add(UpdateOtp(otp: value)),
                    defaultPinTheme: state.status == OtpStatus.error
                        ? errorPinTheme
                        : defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    onCompleted: (_) => otpBloc.add(VerifyOtp()),
                    validator: (value) {
                      if (state.status == OtpStatus.error)
                        return state.errorMessage;
                      return null;
                    },
                    errorTextStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    autofocus: true,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: state.timeLeft < 10 ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Expires in ${state.timeLeft} seconds',
                      style: TextStyle(
                        color: state.timeLeft < 10 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed:
                        state.canResendOTP && state.status != OtpStatus.loading
                        ? () => otpBloc.add(ResendOtp())
                        : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 16,
                        color: state.canResendOTP
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (state.status == OtpStatus.error)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              state.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
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
}
