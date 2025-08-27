import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:membership_erp_app/auth/models/token_models.dart';
import 'package:membership_erp_app/auth/view_model/auth_bloc.dart';
import 'package:membership_erp_app/auth/views/signin_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../view/landing_screen/weclcome_screen/screen/welcome_screen.dart';
import '../../auth/view_model/auth_event.dart';
import '../../common/constants/shared_constant.dart';
import '../../main.dart';

class AuthorizationInterceptor extends Interceptor {
  static const String _authorizationHeader = 'Authorization';
  static const String _deviceIdHeader = 'DeviceId';
  bool _isRefreshing = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString(SharedConstant.accessToken);
    String? deviceId = prefs.getString(SharedConstant.deviceId);

    if (apiKey != null && apiKey.isNotEmpty) {
      options.headers[_authorizationHeader] = 'Bearer $apiKey';
      options.headers[_deviceIdHeader] = deviceId ?? '';
      options.extra['skipGlobalErrorHandling'] = true;
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // var talker = Talker();

    Response<dynamic>? response = err.response;
    String? errorMessage = _getErrorMessage(response?.data);

    try {
      if (err.type == DioExceptionType.connectionError) {
        // talker.warning('Please check your internet connection. 😥');
        // _showError('Please check your internet connection.');
      } else if (err.type == DioExceptionType.connectionTimeout) {
        // talker.warning(
        //   'Connection timeout. Please check your internet connection',
        // );
        _showError(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (response?.statusCode == 401) {
        if (!_isRefreshing) {
          _isRefreshing = true;
          try {
            refreshToken();
          } catch (e) {
            _isRefreshing = false;
            _showError("Failed to refresh token. Please login again.");
            navigatorKey.currentState?.pushReplacementNamed(
              Signin.routeName,
            );
          }
        } else {
          _showError("Authentication error. Please login again.");
          navigatorKey.currentState?.pushReplacementNamed(Signin.routeName);
        }
      } else if (response?.statusCode == 403) {
        _showError('Acess denied for user \n Please Contact Administrator ');
      } else if (response?.statusCode == 503) {
        _showError('Service Unavailable \n Please Contact Administrator ');
      } else if (response?.statusCode == 405) {
        // talker.warning('Api Method is invalid');
        _showError('Api Method is invalid');
      } else if (errorMessage != null) {
        _showError(errorMessage);
      } else {
        _showError('An unexpected error occurred.');
      }
    } finally {
      handler.next(err);
    }
  }

  String? _getErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is String) {
      if (responseData.contains('Service Unavailable')) {
        return 'Server is temporarily unavailable. Please try again later.';
      }
      return 'An unexpected error occurred';
    }

    try {
      if (responseData is Map) {
        return responseData['ResponseMSG'] ??
            responseData['error_description'] ??
            responseData['Error_Description'] ??
            responseData['error'] ??
            responseData['Error'] ??
            responseData['message'] ??
            responseData['Message'] ??
            responseData['data'] ??
            responseData['Data'] ??
            responseData['details'] ??
            responseData['Details'] ??
            'Something went wrong';
      }
    } catch (e) {
      // Talker().error('Error parsing responseData: $e'); // Log for debugging
    }

    return 'Something went wrong';
  }

  void _showError(String message) {
    EasyLoading.showToast(
      message,
      toastPosition: EasyLoadingToastPosition.center,
      duration: const Duration(seconds: 3),
    );
  }

  void _navigateToSignin() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared
      ..remove(SharedConstant.expires)
      ..remove(SharedConstant.accessToken);

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Signin.routeName,
      (route) => false,
    );
  }

  Future<TokenModel?> refreshToken() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String uername = shared.getString(SharedConstant.userName) ?? '';
    String password = shared.getString(SharedConstant.loginPassword) ?? '';

    if (uername.isEmpty && password.isEmpty) {
      _navigateToSignin();
      return null;
    }
    try {
      navigatorKey.currentContext!.read<AuthBloc>()
        ..add(OnUserNameChange(username: uername))
        ..add(OnPasswordChange(password: password))
        ..add(SigninUser());
    } catch (e) {
      _navigateToSignin();
      return null;
    }
    _navigateToSignin();
    return null;
  }
}
