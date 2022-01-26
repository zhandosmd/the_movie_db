import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final loginTextController = TextEditingController(text: 'zhandosmd');
  final passwordTextController = TextEditingController(text: 'Qazaq123');

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = "Заполните логин и пароль";
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();
    String? sessionId;
    int? accountId;
    try{
      sessionId = await _apiClient.auth(username: login, password: password);
      accountId = await _apiClient.getAccountInfo(sessionId);
    } on ApiClienException catch (e){
      switch(e.type){
        case ApiClienExceptionType.Network:
          _errorMessage = "Сервер не доступен. Проверьте подключение к интернету";
          break;
        case ApiClienExceptionType.Auth:
          _errorMessage = "Неверный логин пароль!";
          break;
        case ApiClienExceptionType.Other:
          _errorMessage = "Произошла ошибка. Попробуйте еще раз";
          break;
      }
    }
    _isAuthProgress = false;
    if(_errorMessage!=null){
      notifyListeners();
      return;
    }
    if(sessionId == null || accountId == null){
      _errorMessage = "Неизвестная ошибка, повторите попытку";
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);

    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen);
  }
}
