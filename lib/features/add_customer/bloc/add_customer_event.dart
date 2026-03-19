import 'package:equatable/equatable.dart';

abstract class AddCustomerEvent extends Equatable {
  const AddCustomerEvent();

  @override
  List<Object?> get props => [];
}

class InitializeAddCustomer extends AddCustomerEvent {}

class ResetAddCustomerState extends AddCustomerEvent {}

class SetAddCustomerReady extends AddCustomerEvent {}

class SetAddCustomerError extends AddCustomerEvent {
  final String message;

  const SetAddCustomerError(this.message);

  @override
  List<Object?> get props => [message];
}

class SetAddCustomerProcessing extends AddCustomerEvent {
  final String message;

  const SetAddCustomerProcessing(this.message);

  @override
  List<Object?> get props => [message];
}

class AddCustomerImage extends AddCustomerEvent {
  final dynamic image;

  const AddCustomerImage(this.image);

  @override
  List<Object?> get props => [image];
}

class ClearCustomerImages extends AddCustomerEvent {}
