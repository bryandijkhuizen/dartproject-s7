import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RouterExtentions on BuildContext {
  void goBack(String fallbackLocation) {
    canPop() ? pop() : go(fallbackLocation);
  }
}
