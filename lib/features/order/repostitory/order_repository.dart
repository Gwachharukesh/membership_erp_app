import 'package:fpdart/fpdart.dart';
import 'package:membership_erp_app/features/order/models/order_model.dart';

abstract class OrderRepository {
  Either<String, List<OrderModel>> getOrder();
}

class OrderRepositoryImpl extends OrderRepository {
  @override
  Either<String, List<OrderModel>> getOrder() {
    final List<OrderModel> orders = [];
    for (int i = 0; i < ordersData.length; i++) {
      orders.add(OrderModel.fromJson(ordersData[i]));
    }
    return Right(orders);
  }
}
