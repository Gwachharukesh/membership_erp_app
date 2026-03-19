import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/auth/views/signin_view.dart';
import 'package:mart_erp/common/widgets/lottie_animated_widget.dart';
import 'package:mart_erp/features/otp/bloc/otp_bloc.dart';
import 'package:mart_erp/features/otp/bloc/otp_event.dart';
import 'package:mart_erp/features/otp/model/otp_genetate_model.dart';
import 'package:mart_erp/features/otp/model/otp_verifiction_state_model.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({
    required this.otpGenetateData,
    super.key,
    this.onVerificationSuccess,
  });

  final OtpGenerateModel otpGenetateData;
  final VoidCallback? onVerificationSuccess;

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late OtpBloc _otpBloc;

  @override
  void initState() {
    super.initState();
    _otpBloc = OtpBloc(widget.otpGenetateData);
  }

  @override
  void dispose() {
    _otpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _otpBloc,
      child: BlocBuilder<OtpBloc, OTPVerificationState>(
        builder: (context, state) {
          var defaultPinTheme = PinTheme(
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

          var focusedPinTheme = defaultPinTheme.copyDecorationWith(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          );

          var errorPinTheme = defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
          );

          // Handle success state
          if (state.customerCreationSuccess && state.otpVerified) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Signin()),
                (route) => false,
              );
            });
          }

          // Handle failure state
          if (state.customerCreationFailed) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 70,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Customer Registration Failed',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Reset the state and pop back to previous screen
                        //   notifier.resetState();
                        Navigator.pop(context);
                      },
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Loading state during OTP verification
          if (state.otpVerified && !state.customerCreationSuccess) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieAnimatedWidget.creatingCustomer(),
                    const SizedBox(height: 20),
                    const Text('Creating your account...'),
                  ],
                ),
              ),
            );
          }

          // Main OTP verification UI
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
                        widget.otpGenetateData.emailId ?? '',
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
                          onChanged: (value) =>
                              context.read<OtpBloc>().add(InitializeOtp(value)),
                          defaultPinTheme: state.showError
                              ? errorPinTheme
                              : defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          onCompleted: (value) =>
                              context.read<OtpBloc>().add(VerifyOtp(value)),
                          validator: (value) {
                            if (state.showError) return state.errorMessage;
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
                            color: state.timeLeft < 10
                                ? Colors.red
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Expires in ${state.timeLeft} seconds',
                            style: TextStyle(
                              color: state.timeLeft < 10
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: TextButton(
                          onPressed: state.canResendOTP && !state.isLoading
                              ? () => context.read<OtpBloc>().add(ResendOtp())
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
                      if (state.showError)
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
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
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
        },
      ),
    );
  }
}
