import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/features/customer/bloc/add_customer_state.dart';

import 'add_customer_event.dart';

class AddCustomerBloc extends Bloc<AddCustomerEvent, AddCustomerState> {
  AddCustomerBloc() : super(const AddCustomerState()) {
    on<AddCustomerImagePicked>(_onImagePicked);
    on<AddCustomerImagesCleared>(_onImagesCleared);
    on<AddCustomerSetReady>(_onSetReady);
    on<AddCustomerReset>(_onReset);
  }

  void _onImagePicked(AddCustomerImagePicked event, Emitter<AddCustomerState> emit) {
    emit(state.copyWith(pickedImages: [...state.pickedImages, event.file]));
  }

  void _onImagesCleared(AddCustomerImagesCleared event, Emitter<AddCustomerState> emit) {
    emit(state.copyWith(pickedImages: []));
  }

  void _onSetReady(AddCustomerSetReady event, Emitter<AddCustomerState> emit) {
    emit(state.copyWith(status: ApiResponseStatus.ready));
  }

  void _onReset(AddCustomerReset event, Emitter<AddCustomerState> emit) {
    emit(const AddCustomerState());
  }
}
