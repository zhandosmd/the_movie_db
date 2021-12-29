import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier{}

class AuthProvider extends InheritedNotifier {
  final AuthModel model;

  const AuthProvider( {
    Key? key,
    required Widget child,
    required this.model,
  }) : super(key: key, notifier: model,child: child);

  static AuthProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  }

  static AuthProvider? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
    return widget is AuthProvider ? widget : null;
  }
}