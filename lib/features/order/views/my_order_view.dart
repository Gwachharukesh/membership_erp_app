import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:membership_erp_app/features/order/view_model/order_bloc/order_event.dart';

import '../view_model/order_bloc/order_bloc.dart';
import '../view_model/order_bloc/order_state.dart';
import '../widgets/order_widget.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  @override
  void initState() {
    context.read<OrderBloc>().add(FetchOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderFetchedSuccessfully) {
          if (state.orders.isEmpty) {
            return Center(child: Text("No order History Found!"));
          }
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              return OrderWidget(theme: theme, order: state.orders[index]);
            },
          );
        } else if (state is ErrorFetchingOrder) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
