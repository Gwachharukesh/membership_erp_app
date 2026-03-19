import 'package:flutter/material.dart';

class CustomerCreatedSucessfulDemoScreen extends StatelessWidget {
  const CustomerCreatedSucessfulDemoScreen({
    required this.onContinue,
    super.key,
  });
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Text('Customer created successfully!'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onContinue,
              child: const Text('Continue to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
