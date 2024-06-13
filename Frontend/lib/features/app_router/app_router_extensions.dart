import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RouterExtensions on BuildContext {
  void goBack(String fallbackLocation) {
    canPop() ? pop() : go(fallbackLocation);
  }
}
