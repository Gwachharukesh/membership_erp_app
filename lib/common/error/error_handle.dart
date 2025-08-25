import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:membership_erp_app/main.dart';

import '../../config/routes/route_not_found_view.dart';

void showException(Object error) {
  try {
    if (error is SocketException) {
      EasyLoading.showToast(
        'Please check your internet connection',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } else if (error is TimeoutException) {
      EasyLoading.showToast(
        'Failed to get Data in 50 second',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } else if (error is OutOfMemoryError) {
      // Handle out of memory errors
      EasyLoading.showToast(
        'Out of Memory Error:',
        toastPosition: EasyLoadingToastPosition.top,
      );
      return;
      // Perform memory management actions or notify the user
    } else if (error is IOException) {
      EasyLoading.showToast(
        'Io Exception:',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } else if (error is PlatformException) {
      EasyLoading.showToast(
        'Platform Exception: ${error.message}. Please try again.',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } else if (error is FormatException) {
      EasyLoading.showToast(
        'Format Exception: ${error.message}',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } else if (error is FileSystemException) {
      EasyLoading.showToast(
        'HTTP Exception: ${error.message}',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } else if (error is DioException) {
      showDioException(error: error);
    }
  } catch (exception) {
    EasyLoading.showToast(
      'Unknown Exception: $exception. Please try again.',
      toastPosition: EasyLoadingToastPosition.top,
    );
  }
}

void showDioException({
  required DioException error,
  String? endpoint,
  String? userId,
}) async {
  // String method = error.requestOptions.method;
  // String apiEndPoint = endpoint ?? error.requestOptions.baseUrl.split('V1/').last;

  String errorMessage = await getErrorMessage(error);

  if (errorMessage == 'Unauthorized') {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      RouteNotFoundView.routeName,
      (route) => true,
    );
  } else {
    EasyLoading.showToast(
      toastPosition: EasyLoadingToastPosition.top,
      errorMessage,
      duration: const Duration(seconds: 2),
    );
  }

  // Show toast with error message
}

Future<String> getErrorMessage(DioException error) async {
  var statusCode = error.response?.statusCode;
  String errorMsg = '';

  if (error.message != null) {
    if (error.message!.contains('Failed host lookup') ||
        error.message!.contains('connection error') ||
        error.message!.contains('SocketException') ||
        error.message!.contains('Network connection failed')) {
      //  ref
      //                   .read(bottonStateProvider.notifier)
      //                   .update((state) => true);
      errorMsg = 'Please check your internet connection';
    } else if (error.message!.contains('PlatformException') ||
        error.message!.contains('IO_ERROR')) {
      errorMsg = 'A network error occurred. Please try again';
    } else if (error.message!.contains('unauthorized') || statusCode == 401) {
      errorMsg = 'Unauthorized';
      // Handle unauthorized error (e.g., redirect to login screen)
      // navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //   Routes.staticLoginScreen.name,
      //   (route) => true,
      // );
    }
  }

  if (errorMsg.isEmpty) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        errorMsg = 'Something is wrong with the connection';
        break;

      case DioExceptionType.receiveTimeout:
        errorMsg = 'Request Time Out';
        break;

      // case DioExceptionType.badResponse:
      //   errorMsg = error.response?.data['ResponseMSG'];

      //   break;

      case DioExceptionType.badResponse:
        // Safely decode the response data if it's a string
        if (error.response?.data is String) {
          try {
            var decodedData = json.decode(error.response!.data);
            errorMsg =
                decodedData['ResponseMSG'] ?? 'Unexpected error occurred';
          } catch (e) {
            errorMsg = 'Invalid response format';
          }
        } else if (error.response?.data is Map) {
          // Handle the case where data is already a Map
          errorMsg =
              error.response?.data['ResponseMSG'] ??
              'Unexpected error occurred';
        } else {
          errorMsg = 'Unexpected error occurred';
        }
        break;

      // case DioExceptionType.badResponse:
      //   errorMsg = error.response?.data['ResponseMSG'];

      //   break;

      case DioExceptionType.connectionTimeout:
        errorMsg = 'Connection Timeout , Please check your internet speed';
        break;

      case DioExceptionType.sendTimeout:
        errorMsg = 'Connection Timeout , Please check your internet speed';
        break;

      default:
        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              errorMsg =
                  error.response?.data['ResponseMSG'] ??
                  error.response?.data['error_description'] ??
                  error.response?.data['Message'] ??
                  'Bad Syntax, Please Check Request';
              break;

            case 404:
              errorMsg =
                  error.response?.data['Message'] ??
                  'URL Not Found, Please Check Request';
              break;

            case 403:
            case 405:
              errorMsg =
                  error.response?.data['Message'] ??
                  'Forbidden. Try again later, Please Check Request';
              break;

            case 406:
              errorMsg =
                  error.response?.data['Message'] ?? 'Check request headers';
              break;

            case 408:
              errorMsg =
                  error.response?.data['Message'] ?? 'Request Timeout Error';
              break;

            case 410:
              errorMsg = 'Resource requested is no longer available';
              break;

            case 500:
              errorMsg = 'Internal Server Error';
              break;

            case 504:
              errorMsg = 'Gateway Timeout';
              break;

            case 522:
              errorMsg = 'Connection Timeout';
              break;

            case 599:
              errorMsg = 'Network Connect Timeout Error';
              break;

            case 503:
              errorMsg = 'Please check Internet Connection';
              break;

            case 598:
              errorMsg = 'Network Read Timeout Error';
              break;

            default:
              errorMsg = 'Something went wrong. Try again later';

              break;
          }
        }
    }
  }
  return errorMsg;
}
