import 'package:equatable/equatable.dart';

import '../../models/order_model.dart';

abstract class OrderState extends Equatable{
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState{}
final class FetchingOrders extends OrderState{}
final class OrderFetchedSuccessfully extends OrderState{
  final List<OrderModel> orders;
  const OrderFetchedSuccessfully(this.orders);

  @override
  List<Object> get props => [orders];
}
final class ErrorFetchingOrder extends OrderState{
  final String message;
  const ErrorFetchingOrder(this.message);

  @override
  List<Object> get props => [message];
}