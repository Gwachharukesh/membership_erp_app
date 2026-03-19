import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/features/otp/model/otp_genetate_model.dart';
import 'package:mart_erp/features/otp/service/add_customer_service.dart';
import 'package:mart_erp/features/otp/service/otp_service.dart';

import '../model/check_otp_validation_model.dart';
import '../model/otp_verifiction_state_model.dart';
import 'otp_event.dart';

class OtpBloc extends Bloc<OtpEvent, OTPVerificationState> {
  OtpBloc(this.otpGenerateData) : super(OTPVerificationState.initial()) {
    on<InitializeOtp>(_onInitialize);
    on<VerifyOtp>(_onVerifyOtp);
    on<ResendOtp>(_onResendOtp);
    on<ResetOtp>(_onReset);
  }

  final OtpGenerateModel otpGenerateData;
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _startTimer(Emitter<OTPVerificationState> emit) {
    _timer?.cancel();
    var timeLeft = 60;
    emit(state.copyWith(timeLeft: timeLeft, canResendOTP: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft--;
      if (timeLeft > 0) {
        emit(state.copyWith(timeLeft: timeLeft, canResendOTP: timeLeft <= 1));
      } else {
        timer.cancel();
        emit(
          state.copyWith(
            showError: true,
            errorMessage: "OTP expired. Please request a new one.",
            canResendOTP: true,
            timeLeft: 0,
          ),
        );
      }
    });
  }

  void _onInitialize(InitializeOtp event, Emitter<OTPVerificationState> emit) {
    _startTimer(emit);
    emit(
      state.copyWith(
        otp: event.otp,
        isPinComplete: event.otp.length == 6,
        showError: false,
        errorMessage: '',
      ),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtp event,
    Emitter<OTPVerificationState> emit,
  ) async {
    if (state.timeLeft <= 0) {
      emit(
        state.copyWith(
          showError: true,
          errorMessage: "OTP expired. Please request a new one.",
        ),
      );
      return;
    }

    if (event.otp.length != 6) return;

    emit(
      state.copyWith(
        isLoading: true,
        showError: false,
        otpVerified: false,
        customerCreationSuccess: false,
        customerCreationFailed: false,
      ),
    );

    try {
      var otpData = OtpValidationRequestModel(
        otp: event.otp,
        refId: otpGenerateData.refId!,
        uniqueId: otpGenerateData.uniqueId!,
      );

      var response = await OtpService.verifyOTP(requestData: otpData);

      if (response.isSuccess ?? false) {
        _timer?.cancel();
        emit(state.copyWith(otpVerified: true));

        if (otpGenerateData.addCustomerModel != null) {
          try {
            var customerResponse = await AddCustomerService.savenewCustomer(
              otpGenerateData.addCustomerModel!.copyWith(otp: event.otp),
            );

            if (customerResponse.isSuccess ?? false) {
              emit(
                state.copyWith(
                  isLoading: false,
                  customerCreationSuccess: true,
                  customerCreationFailed: false,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  isLoading: false,
                  customerCreationSuccess: false,
                  customerCreationFailed: true,
                  errorMessage:
                      customerResponse.responseMSG ??
                      'Customer creation failed',
                ),
              );
            }
          } catch (e) {
            emit(
              state.copyWith(
                isLoading: false,
                customerCreationSuccess: false,
                customerCreationFailed: true,
                errorMessage: 'Failed to create customer: $e',
              ),
            );
          }
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            showError: true,
            errorMessage: response.responseMsg ?? 'Invalid OTP',
            otp: '',
            isPinComplete: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          showError: true,
          customerCreationFailed: true,
          errorMessage: 'Verification failed: $e',
        ),
      );
    }
  }

  Future<void> _onResendOtp(
    ResendOtp event,
    Emitter<OTPVerificationState> emit,
  ) async {
    if (!state.canResendOTP) return;

    _timer?.cancel();
    emit(OTPVerificationState.initial());
    _startTimer(emit);

    try {
      await OtpService.generateOtp(otpData: otpGenerateData);
    } catch (e) {
      emit(
        state.copyWith(
          showError: true,
          errorMessage: 'Failed to resend OTP: $e',
        ),
      );
    }
  }

  void _onReset(ResetOtp event, Emitter<OTPVerificationState> emit) {
    _timer?.cancel();
    emit(OTPVerificationState.initial());
    _startTimer(emit);
  }
}
