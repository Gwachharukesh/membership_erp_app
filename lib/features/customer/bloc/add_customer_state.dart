import 'dart:io';

import 'package:equatable/equatable.dart';

import '../add_customer_model.dart';

enum ApiResponseStatus {
  ready,
  processing,
  success,
  error,
  offline,
  duplicate,
  networkError,
}

class AddCustomerState extends Equatable {
  const AddCustomerState({
    this.customer,
    this.status = ApiResponseStatus.ready,
    this.errorMessage,
    this.uuid,
    this.pickedImages = const [],
  });

  final AddCustomerModel? customer;
  final ApiResponseStatus status;
  final String? errorMessage;
  final String? uuid;
  final List<File> pickedImages;

  AddCustomerState copyWith({
    AddCustomerModel? customer,
    ApiResponseStatus? status,
    String? errorMessage,
    String? uuid,
    List<File>? pickedImages,
  }) {
    return AddCustomerState(
      customer: customer ?? this.customer,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      uuid: uuid ?? this.uuid,
      pickedImages: pickedImages ?? this.pickedImages,
    );
  }

  @override
  List<Object?> get props => [customer, status, errorMessage, uuid, pickedImages];
}
