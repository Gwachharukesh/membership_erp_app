import 'package:bloc/bloc.dart';
import 'package:membership_erp_app/features/order/repostitory/order_repository.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repo;
  OrderBloc(this._repo) : super(OrderInitial()) {
    on<FetchOrders>((event, emit) {
      emit(FetchingOrders());
      final response = _repo.getOrder();
      response.fold(
        (message) => emit(ErrorFetchingOrder(message)),
        (orders) => emit(OrderFetchedSuccessfully(orders)),
      );
    });
  }
}
