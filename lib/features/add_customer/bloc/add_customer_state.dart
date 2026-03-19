import 'package:equatable/equatable.dart';

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
  final ApiResponseStatus status;
  final String? errorMessage;
  final List<dynamic> pickedImages;

  const AddCustomerState({
    required this.status,
    this.errorMessage,
    this.pickedImages = const [],
  });

  AddCustomerState copyWith({
    ApiResponseStatus? status,
    String? errorMessage,
    List<dynamic>? pickedImages,
  }) {
    return AddCustomerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      pickedImages: pickedImages ?? this.pickedImages,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, pickedImages];
}
