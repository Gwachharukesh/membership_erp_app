import 'package:flutter/material.dart';

class LottieAnimatedWidget {
  static Widget creatingCustomer() {
    return const CircularProgressIndicator();
  }

  static Widget customerCreatedSuccessful() {
    return const Icon(Icons.check_circle, color: Colors.green, size: 100);
  }
}
