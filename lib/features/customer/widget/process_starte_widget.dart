import 'package:flutter/material.dart';

import 'package:mart_erp/features/customer/bloc/add_customer_state.dart';

class CustomerProcessingWidget extends StatelessWidget {
  const CustomerProcessingWidget({
    required this.customerstate,
    required this.onRetry,
    required this.readyContent,
    this.navigate,
    this.message,
    super.key,
  });
  final AddCustomerState customerstate;
  final VoidCallback onRetry;
  final Widget readyContent;
  final dynamic navigate;
  final String? message;
  @override
  Widget build(BuildContext context) {
    return switch (customerstate.status) {
      ApiResponseStatus.error => CustomerErrorWidget(
        error: customerstate.errorMessage ?? '',
        onRetry: onRetry,
      ),
      ApiResponseStatus.duplicate => DuplicateCustomerWidget(
        onRetry: onRetry,
        navigate: navigate,
        responseMsg: customerstate.errorMessage ?? message,
      ),
      ApiResponseStatus.offline => CustomerLoadingWidget(
        loadingMessage: message,
      ),
      ApiResponseStatus.processing => const CustomerLoadingWidget(),
      ApiResponseStatus.success => const CustomerSuccessWidget(),
      ApiResponseStatus.ready => readyContent,
      ApiResponseStatus.networkError => const NetworkErrorWidget(),
    };
  }
}

class CustomerLoadingWidget extends StatelessWidget {
  const CustomerLoadingWidget({super.key, this.loadingMessage});

  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            loadingMessage ?? 'Loading customer data...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait a moment',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_connected_no_internet_4,
              color: Theme.of(context).colorScheme.error,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              'Network Connection Error/ इन्टरनेट समस्या',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Internet slow /इन्टरनेट जडान नभएकोले कारण तपाईको डाटा offline मा save भएको छ। Checkout गर्नु अघि data sync गर्नुहोला ।",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DuplicateCustomerWidget extends StatelessWidget {
  const DuplicateCustomerWidget({
    required this.onRetry,
    super.key,
    this.responseMsg,
    this.navigate,
  });

  final VoidCallback onRetry;
  final dynamic navigate;
  final String? responseMsg;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.dynamic_feed, size: 50),
        const SizedBox(height: 20),
        Text(
          'Duplicate Customer',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text('$responseMsg', style: Theme.of(context).textTheme.bodySmall),
        TextButton.icon(
          onPressed: () {
            onRetry();
          },
          label: const Text('Back'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ],
    ),
  );
}

class CustomerSuccessWidget extends StatelessWidget {
  const CustomerSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            'Customer Created Successful!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Customer added successfully',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class CustomerErrorWidget extends StatelessWidget {
  const CustomerErrorWidget({
    required this.error,
    required this.onRetry,
    super.key,
  });
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'Customer Add Failed',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                onRetry();
              },
              label: const Text('Back'),
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ],
        ),
      ),
    );
  }
}
