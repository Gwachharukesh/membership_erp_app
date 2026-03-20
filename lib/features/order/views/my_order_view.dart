import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/features/order/models/order_model.dart';
import 'package:mart_erp/features/order/view_model/order_bloc/order_event.dart';
import 'package:mart_erp/features/order/view_model/order_bloc/order_bloc.dart';
import 'package:mart_erp/features/order/view_model/order_bloc/order_state.dart';
import 'package:mart_erp/features/order/widgets/order_widget.dart';
import 'package:shimmer/shimmer.dart';

/// Flipkart-style My Orders screen.
class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  String _filter = 'All'; // All, Completed, Cancelled

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrders());
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    if (_filter == 'All') return orders;
    return orders
        .where((o) => o.status.toLowerCase() == _filter.toLowerCase())
        .toList();
  }

  Future<void> _onRefresh() async {
    context.read<OrderBloc>().add(FetchOrders());
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderFetchedSuccessfully) {
          final filtered = _filterOrders(state.orders);

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _OrderFilterBar(
                    selected: _filter,
                    onSelected: (v) => setState(() => _filter = v),
                  ),
                ),
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    child: _EmptyState(
                      filter: _filter,
                      onViewAll: () => setState(() => _filter = 'All'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 24 + MediaQuery.of(context).padding.bottom + 72,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => OrderWidget(
                          order: filtered[index],
                          onTrack: () {
                            // TODO: Navigate to track order
                          },
                          onReorder: () {
                            // TODO: Reorder flow
                          },
                        ),
                        childCount: filtered.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        if (state is ErrorFetchingOrder) {
          return _ErrorState(
            message: state.message,
            onRetry: () => context.read<OrderBloc>().add(FetchOrders()),
          );
        }

        return _LoadingState();
      },
    );
  }
}

class _OrderFilterBar extends StatelessWidget {
  const _OrderFilterBar({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: colorScheme.surface,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selected == 'All',
            onTap: () => onSelected('All'),
            theme: theme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Completed',
            isSelected: selected == 'Completed',
            onTap: () => onSelected('Completed'),
            theme: theme,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Cancelled',
            isSelected: selected == 'Cancelled',
            onTap: () => onSelected('Cancelled'),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.12)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.filter,
    required this.onViewAll,
  });

  final String filter;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              filter == 'All'
                  ? 'No orders yet'
                  : 'No $filter orders',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              filter == 'All'
                  ? 'Your order history will appear here'
                  : 'Try changing the filter to see more orders',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (filter != 'All') ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View All Orders',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
