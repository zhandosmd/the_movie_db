import 'package:flutter/cupertino.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class MyAppModel{
  final _sessionDataProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    _isAuth = sessionId != null;
  }

  Future<void> resetSession(BuildContext context) async{
    await _sessionDataProvider.setSessionId(null);
    await _sessionDataProvider.setAccountId(null);

    await Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRouteNames.auth,
      (route) => false
    );
  }
}