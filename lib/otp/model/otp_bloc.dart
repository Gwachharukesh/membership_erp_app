import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/features/customer/service/add_customer_service.dart';
import 'package:mart_erp/otp/model/check_otp_validation_model.dart';
import 'package:mart_erp/otp/model/otp_genetate_model.dart';
import 'package:mart_erp/otp/service/otp_service.dart';

import '../model/otp_event.dart';
import '../model/otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpGenerateModel otpGenerateData;
  Timer? _timer;

  OtpBloc({required this.otpGenerateData}) : super(const OtpState()) {
    on<UpdateOtp>(_onUpdateOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<ResendOtp>(_onResendOtp);
    on<ResetOtpState>(_onResetOtpState);

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    emit(state.copyWith(timeLeft: 60, canResendOTP: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        emit(
          state.copyWith(
            timeLeft: state.timeLeft - 1,
            canResendOTP: state.timeLeft <= 1,
          ),
        );
      } else {
        timer.cancel();
        emit(
          state.copyWith(
            status: OtpStatus.otpExpired,
            errorMessage: "OTP expired. Please request a new one.",
            canResendOTP: true,
          ),
        );
      }
    });
  }

  void _onUpdateOtp(UpdateOtp event, Emitter<OtpState> emit) {
    emit(
      state.copyWith(
        otp: event.otp,
        isPinComplete: event.otp.length == 6,
        status: OtpStatus.initial,
        errorMessage: '',
      ),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<OtpState> emit) async {
    if (state.timeLeft <= 0) {
      emit(
        state.copyWith(
          status: OtpStatus.otpExpired,
          errorMessage: "OTP expired. Please request a new one.",
        ),
      );
      return;
    }

    if (state.otp.length != 6) return;

    emit(state.copyWith(status: OtpStatus.loading));

    try {
      var otpData = OtpValidationRequestModel(
        otp: state.otp,
        refId: otpGenerateData.refId!,
        uniqueId: otpGenerateData.uniqueId!,
      );

      var response = await OtpService.verifyOTP(requestData: otpData);

      if (response.isSuccess ?? false) {
        _timer?.cancel();
        emit(state.copyWith(status: OtpStatus.otpVerified));

        if (otpGenerateData.addCustomerModel != null) {
          try {
            var customerResponse = await AddCustomerService.savenewCustomer(
              otpGenerateData.addCustomerModel!.copyWith(otp: state.otp),
            );

            if (customerResponse.isSuccess ?? false) {
              emit(state.copyWith(status: OtpStatus.customerCreationSuccess));
            } else {
              emit(
                state.copyWith(
                  status: OtpStatus.customerCreationFailed,
                  errorMessage:
                      customerResponse.responseMSG ??
                      'Customer creation failed',
                ),
              );
            }
          } catch (e) {
            emit(
              state.copyWith(
                status: OtpStatus.customerCreationFailed,
                errorMessage: 'Failed to create customer: $e',
              ),
            );
          }
        }
      } else {
        emit(
          state.copyWith(
            status: OtpStatus.error,
            errorMessage: response.responseMsg ?? 'Invalid OTP',
            otp: '',
            isPinComplete: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: OtpStatus.error,
          errorMessage: 'Verification failed: $e',
        ),
      );
    }
  }

  Future<void> _onResendOtp(ResendOtp event, Emitter<OtpState> emit) async {
    if (!state.canResendOTP) return;

    _timer?.cancel();
    emit(const OtpState());
    _startTimer();

    try {
      await OtpService.generateOtp(otpData: otpGenerateData);
    } catch (e) {
      emit(
        state.copyWith(
          status: OtpStatus.error,
          errorMessage: 'Failed to resend OTP: $e',
        ),
      );
    }
  }

  void _onResetOtpState(ResetOtpState event, Emitter<OtpState> emit) {
    _timer?.cancel();
    emit(const OtpState());
    _startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
