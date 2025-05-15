import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  /// Push to a new page
  Future<T?> pushTo<T>(Widget page) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push and replace current page
  Future<T?> pushReplacementTo<T, TO>(Widget page, {TO? result}) {
    return Navigator.pushReplacement<T, TO>(
      this,
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Push and remove all previous routes
  Future<T?> pushAndRemoveUntilTo<T>(Widget page) {
    return Navigator.pushAndRemoveUntil<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
      (Route<dynamic> route) => false,
    );
  }

  /// Push until a certain condition is met
  Future<T?> pushAndRemoveUntilCondition<T>(
      Widget page, bool Function(Route<dynamic>) predicate) {
    return Navigator.pushAndRemoveUntil<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  /// Pop the current page
  void popPage<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }
}
