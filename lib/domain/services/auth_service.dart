import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';

class AuthService{
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  Future<bool> isAuth() async{
    final sessionId = await _sessionDataProvider.getSessionId();
    return sessionId != null;
  }

  Future<void> login(String login, String password) async{
    final sessionId = await _apiClient.auth(username: login, password: password);
    final accountId = await _apiClient.getAccountInfo(sessionId);

    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }
}