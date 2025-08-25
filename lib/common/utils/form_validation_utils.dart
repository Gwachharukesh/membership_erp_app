import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FormValidationUtils {
  static const doubleRegex = r'[-+]?[0-9]*\.?[0-9]+';
  static const doubleRegexWithTwoDecimal = r'^(\d+)?\.?\d{0,2}';
  static const doubleBetweenZtHTwoDecimal =
      r'^100(\.[0]{1,2})?|([0-9]|[1-9][0-9])(\.[0-9]{1,2})?$';

  // REGEX EMAIL
  static const emailPattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";

  /// REGEX PASSWORD
  static const passwordMinThreePattern = r'^.{3,}$';

  /// Minimum eight characters, at least one letter and one number:
  static const passwordMinEightChOneLetOneNumPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';

  /// Minimum eight characters, at least one letter, one number and one special character:
  static const passwordMinEightChOneLetOneNumOneSpChPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';

  ///form field validater that check if empty
  static String? formFieldValidator({
    required value,
    required String fieldName,
    bool nullable = false,
  }) {
    if ((value == null || value.isEmpty) && !nullable) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? oldAndNewPassValidator({
    required pass1,
    required pass2,
  }) {
    if (pass1 == pass2) {
      return 'Old and New Password must be different';
    }
    return null;
  }

  /// check if 1st and 2nd text matched
  static String? passwordMatchValidator({
    required pass1,
    required pass2,
  }) {
    if (pass1 != pass2) {
      return 'password does not match';
    }
    return null;
  }

  static String? formDoubleFieldValidator({
    required value,
    required String fieldName,
    bool nullable = false,
  }) {
    RegExp doublePattern = RegExp(doubleRegex);

    if ((value == null || value.isEmpty) && !nullable) {
      return '$fieldName is required';
    } else if (!doublePattern.hasMatch(value) && !nullable) {
      return 'Invalid Value, only double allowed.';
    }
    return null;
  }

  static String? panNumberValidator(value) => formFieldRegexValidator(
        value: value,
        fieldName: 'PAN/VAT',
        regexExpression: RegExp(r'^\d{9}$'),
        regexMessage: 'Must be a number of length 9',
        nullable: true,
      );

  ///form field validater with custom regex match check
  static String? formFieldRegexValidator({
    required value,
    required String fieldName,
    required RegExp regexExpression,
    required String regexMessage,
    bool nullable = false,
  }) {
    if ((value == null || value.isEmpty) && nullable) {
      return null;
    } else if ((value == null || value.isEmpty) && !nullable) {
      return '$fieldName is required';
    } else if (!regexExpression.hasMatch(value)) {
      return regexMessage;
    }
    return null;
  }

  static String? emailValidator({
    required String? email,
    bool allowEmpty = false,
  }) {
    RegExp emailRegex = RegExp(emailPattern);
    if (allowEmpty) {
      if (email == null || email.isEmpty) {
        return null;
      } else {
        if (!emailRegex.hasMatch(email)) {
          return 'Please enter a valid Email';
        }
      }
    } else {
      if (email == null || email.isEmpty) {
        return 'Email is required.';
      } else if (!emailRegex.hasMatch(email)) {
        return 'Please enter a valid Email';
      }
    }
    return null;
  }

  static String? fullnameValidator({
    required String? value,
    required bool required,
    required String fieldName,
  }) {
    value = value?.trim();
    if (required) {
      if (value == null || value.isEmpty) {
        return '$fieldName is required.';
      }
      if (value.contains(RegExp(r'[0-9]'))) {
        return '$fieldName  cannot contain numbers';
      } else if (value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
        return '$fieldName cannot contain special characters';
      }
      return null;
    } else {
      if (value != null && value.contains(RegExp(r'[0-9]'))) {
        return '$fieldName  cannot contain numbers';
      } else if (value != null &&
          value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
        return '$fieldName cannot contain special characters';
      }
    }

    return null;
  }

  static String? nameValidator({
    required String? value,
    required bool required,
    required String fieldName,
  }) {
    value = value?.trim();
    if (required) {
      if (value == null || value.isEmpty) {
        return '$fieldName is required.';
      }
      if (value.contains(' ')) {
        return 'Space is not allowed';
      }

      if (value.contains(RegExp(r'[0-9]'))) {
        return '$fieldName  cannot contain numbers';
      } else if (value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
        return '$fieldName cannot contain special characters';
      }
      return null;
    } else {
      if (value != null && value.contains(RegExp(r'[0-9]'))) {
        return '$fieldName  cannot contain numbers';
      } else if (value != null &&
          value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
        return '$fieldName cannot contain special characters';
      }
    }
    return null;
  }

  static String? numberValidator({
    required String? value,
    required bool required,
    required String fieldName,
  }) {
    value = value?.trim();
    if (required) {
      if (value == null || value.isEmpty) {
        return '$fieldName is required.';
      }
      if (double.tryParse(value) == null) {
        return '$fieldName must be a valid number (integer or decimal).';
      }
    } else {
      if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
        return '$fieldName must be a valid number (integer or decimal).';
      }
    }
    return null;
  }

  static String? mobileNoValidator({
    required String? number,
    bool isRequired = false,
  }) {
    RegExp regex = RegExp(r'^[0-9]{10}$');

    if (!isRequired && (number == null || number.isEmpty)) {
      return null;
    }
    if (number == null || number.isEmpty) {
      return 'Mobile No. is required.';
    } else if (number.length > 10) {
      return 'Invalid Mobile no : Greater than 10 digit';
    } else if (number.length < 10) {
      return 'Invalid Mobile no : Lesser than 10 digit';
    } else if (!regex.hasMatch(number)) {
      return 'Mobile No should not contain alphabets';
    }

    return null;
  }

  static String? passwordValidator({required String? password}) {
    RegExp passwordRegex = RegExp(passwordMinThreePattern);
    if (password == null || password.isEmpty) {
      return 'Password is required.';
    } else if (!passwordRegex.hasMatch(password)) {
      return 'Password must contain at least 3 characters in lengths containing one small character, one capital character.';
    }
    return null;
  }

  static String? formFieldValidatorWithFocus({
    required value,
    required String fieldName,
    bool nullable = false,
    FocusNode? focusNode,
  }) {
    if ((value == null || value.isEmpty) && !nullable) {
      // Set focus to the provided FocusNode if validation fails
      if (focusNode != null) {
        focusNode.requestFocus();
      }
      return '$fieldName is required';
    } else {}
    return null;
  }
}

/// capitalize first alphabet in text form field
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      TextEditingValue(
        text: capitalize(newValue.text),
        selection: newValue.selection,
      );

  ///set first string to capital
  /// aakash ghimire -> Aakash ghimire
  String capitalize(String value) {
    if (value.trim().isEmpty) return '';
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

// form validation with focus node
class FormValidationManager {
  final _fieldStates = <String, FormFieldValidationState>{};

  FocusNode? getFocusNodeForField(key) {
    _ensureExists(key);

    return _fieldStates[key]?.focusNode;
  }

  FormFieldValidator<dynamic> wrapValidator(
    String key,
    FormFieldValidator<dynamic> validator,
  ) {
    _ensureExists(key);

    return (input) {
      var result = validator(input);

      _fieldStates[key]?.hasError = result?.isNotEmpty ?? false;

      return result;
    };
  }

  List<FormFieldValidationState> get erroredFields => _fieldStates.entries
      .where((s) => s.value.hasError)
      .map((s) => s.value)
      .toList();

  void _ensureExists(String key) {
    _fieldStates[key] ??= FormFieldValidationState(key: key);
  }

  void dispose() {
    for (var s in _fieldStates.entries) {
      s.value.focusNode.dispose();
    }
  }
}

class FormFieldValidationState {
  FormFieldValidationState({required this.key})
      : hasError = false,
        focusNode = FocusNode();
  final String key;

  bool hasError;
  FocusNode focusNode;
}
