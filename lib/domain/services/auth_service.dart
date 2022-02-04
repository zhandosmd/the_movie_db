import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';

class AuthService{
  final _sessionDataProvider = SessionDataProvider();

  Future<bool> isAuth() async{
    final sessionId = await _sessionDataProvider.getSessionId();
    return sessionId != null;
  }
}