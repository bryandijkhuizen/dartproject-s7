import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

extension SnackbarExtension on BuildContext {
  void ShowSnackbar(SnackBar snackbar) {
    ScaffoldMessenger.of(this).showSnackBar(snackbar);
  }
}

extension CompareValidation on ValidationBuilder {
  /// Compares this validator's value with the value
  /// compareValueFN returns.
  /// compareValueFN is a function returning String so that
  /// it will re-execute the function everytime the
  /// validation is done.
  /// This way it will have the updated text values
  /// of i.e. a TextEditingController when doing:
  /// () => textEditingControllerName.text
  ValidationBuilder matches(String? Function() compareValueFN,
          [String msg = 'Fields don\'t match']) =>
      add((value) => value != compareValueFN() ? msg : null);
}
