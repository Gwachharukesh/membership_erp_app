// lib/features/payment/utils/signature_generator.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Generates the HMAC-SHA512 request signature required by OnePG APIs.
///
/// Algorithm:
///   1. Sort payload field keys alphabetically.
///   2. Concatenate the corresponding values (in that order) into one string.
///   3. Compute HMAC-SHA512 of that string using the merchant secret key.
///   4. Return the digest as a lowercase hex string.
abstract class SignatureGenerator {
  /// Generates a signature for [payload] using [secretKey].
  /// The [payload] must NOT include the "Signature" key itself.
  static String generate({
    required Map<String, String> payload,
    required String secretKey,
  }) {
    final sortedKeys = payload.keys.toList()..sort();
    final concatenated = sortedKeys.map((k) => payload[k]!).join();

    final keyBytes = utf8.encode(secretKey);
    final msgBytes = utf8.encode(concatenated);
    final digest = Hmac(sha512, keyBytes).convert(msgBytes);
    return digest.toString(); // already lowercase hex
  }

  /// Builds the value for the `Authorization: Basic …` header.
  static String basicAuth(String username, String password) {
    final encoded = base64.encode(utf8.encode('$username:$password'));
    return 'Basic $encoded';
  }
}
