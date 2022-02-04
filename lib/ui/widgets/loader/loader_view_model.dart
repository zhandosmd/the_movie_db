import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/domain/services/auth_service.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class LoaderViewModel{ // no changeNotifier, cause no need to refresh screen
  final BuildContext context;
  final _authService = AuthService();
  LoaderViewModel(this.context){
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final _isAuth = await _authService.isAuth();
    final nextScreen = _isAuth
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}