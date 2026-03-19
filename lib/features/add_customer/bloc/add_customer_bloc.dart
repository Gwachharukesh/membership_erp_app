import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_customer_event.dart';
import 'add_customer_state.dart';

class AddCustomerBloc extends Bloc<AddCustomerEvent, AddCustomerState> {
  AddCustomerBloc()
    : super(const AddCustomerState(status: ApiResponseStatus.ready)) {
    on<InitializeAddCustomer>(_onInitialize);
    on<ResetAddCustomerState>(_onReset);
    on<SetAddCustomerReady>(_onSetReady);
    on<SetAddCustomerError>(_onSetError);
    on<SetAddCustomerProcessing>(_onSetProcessing);
    on<AddCustomerImage>(_onAddImage);
    on<ClearCustomerImages>(_onClearImages);
  }

  void _onInitialize(
    InitializeAddCustomer event,
    Emitter<AddCustomerState> emit,
  ) {
    emit(const AddCustomerState(status: ApiResponseStatus.ready));
  }

  void _onReset(ResetAddCustomerState event, Emitter<AddCustomerState> emit) {
    emit(const AddCustomerState(status: ApiResponseStatus.ready));
  }

  void _onSetReady(SetAddCustomerReady event, Emitter<AddCustomerState> emit) {
    emit(state.copyWith(status: ApiResponseStatus.ready));
  }

  void _onSetError(SetAddCustomerError event, Emitter<AddCustomerState> emit) {
    emit(
      state.copyWith(
        status: ApiResponseStatus.error,
        errorMessage: event.message,
      ),
    );
  }

  void _onSetProcessing(
    SetAddCustomerProcessing event,
    Emitter<AddCustomerState> emit,
  ) {
    emit(
      state.copyWith(
        status: ApiResponseStatus.processing,
        errorMessage: event.message,
      ),
    );
  }

  void _onAddImage(AddCustomerImage event, Emitter<AddCustomerState> emit) {
    final newImages = List<dynamic>.from(state.pickedImages)..add(event.image);
    emit(state.copyWith(pickedImages: newImages));
  }

  void _onClearImages(
    ClearCustomerImages event,
    Emitter<AddCustomerState> emit,
  ) {
    emit(state.copyWith(pickedImages: []));
  }
}
