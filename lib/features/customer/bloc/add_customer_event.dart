import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddCustomerEvent extends Equatable {
  const AddCustomerEvent();

  @override
  List<Object?> get props => [];
}

class AddCustomerImagePicked extends AddCustomerEvent {
  const AddCustomerImagePicked(this.file);
  final File file;

  @override
  List<Object?> get props => [file];
}

class AddCustomerImagesCleared extends AddCustomerEvent {
  const AddCustomerImagesCleared();
}

class AddCustomerSetReady extends AddCustomerEvent {
  const AddCustomerSetReady();
}

class AddCustomerReset extends AddCustomerEvent {
  const AddCustomerReset();
}
