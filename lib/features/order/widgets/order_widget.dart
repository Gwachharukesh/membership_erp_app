import 'package:flutter/material.dart';

import '../../../common/constants/border_radius_constants.dart';
import '../../../common/constants/paddng_constants.dart';
import '../models/order_model.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.theme, required this.order});

  final ThemeData theme;
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              Container(
                padding: PaddingConstants.a8,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadiusConstants.br8,
                ),
                child: Icon(Icons.delivery_dining, color: Colors.white),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.title),
                  Text(order.orderProducts, overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),

          Row(
            spacing: 5,
            children: [
              Icon(
                (order.status == "Completed")
                    ? Icons.check_circle_outline_outlined
                    : Icons.block,
                color: (order.status == "Completed")
                    ? Colors.green
                    : Colors.red,
                size: 15,
              ),
              Text(
                order.status,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: (order.status == "Completed")
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
