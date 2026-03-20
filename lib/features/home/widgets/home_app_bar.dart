import 'package:flutter/material.dart';
import 'package:mart_erp/config/routes/routes.dart';

/// Home screen app bar with search functionality
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          elevation: 0,
          shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          child: TextField(
            readOnly: true,
            onTap: () => Navigator.pushNamed(context, RouteHelper.categories),
            decoration: InputDecoration(
              hintText: 'Search products, categories...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.outline,
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
