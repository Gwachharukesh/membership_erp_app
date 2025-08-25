import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable{
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class FetchOrders extends OrderEvent{}