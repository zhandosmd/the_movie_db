import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/services/auth_service.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final loginTextController = TextEditingController(text: 'zhandosmd');
  final passwordTextController = TextEditingController(text: 'Qazaq123');

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String login, String password) async{
    try{
      await _authService.login(login, password);
    } on ApiClienException catch (e){
      switch(e.type){
        case ApiClienExceptionType.Network:
          return "Сервер не доступен. Проверьте подключение к интернету";
        case ApiClienExceptionType.Auth:
          return "Неверный логин пароль!";
        case ApiClienExceptionType.SessionExpired:
        case ApiClienExceptionType.Other:
         return "Произошла ошибка. Попробуйте еще раз";
      }
    } catch(e){
      return "Неизвестная ошибка, повторите попытку";
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (!_isValid(login, password)) {
      _updateState("Заполните логин и пароль", false);
      return;
    }
    _updateState(null, true);
    _errorMessage = await _login(login, password);
    if(_errorMessage == null){
      MainNavigation.resetNavigation(context);
    }else{
      _updateState(_errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool isAuthProgress){
    if(_errorMessage == errorMessage && _isAuthProgress == isAuthProgress){
     return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
