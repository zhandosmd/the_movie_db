import 'dart:convert';
import 'dart:io';

import 'package:the_movie_db/domain/entity/popular_movie_response.dart';

enum ApiClienExceptionType{ Network, Auth, Other }

class ApiClienException implements Exception{
  final ApiClienExceptionType type;

  ApiClienException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = "https://api.themoviedb.org/3";
  static const _imageUrl = "https://image.tmdb.org/t/p/w500";
  static const _apiKey = "372932cdecf5549b41a2e614792df3c1";

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validatedToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validatedToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse("$_host$path");
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<T> _get<T>(String path, T Function(dynamic json) parser, [Map<String, dynamic>? parameters]) async {
    final url = _makeUri(path, parameters);
    try{
      // here can be socket exception
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException{
      throw ApiClienException(ApiClienExceptionType.Network);
    } on ApiClienException{
      rethrow; // бросает ошибку повыше
    } catch(_){
      throw ApiClienException(ApiClienExceptionType.Other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser,[
    Map<String, dynamic>? urlParameters,
  ]) async {
    try{
      final url = _makeUri(path, urlParameters);
      final request = await _client.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException{
      throw ApiClienException(ApiClienExceptionType.Network);
    } on ApiClienException{
      rethrow; // бросает ошибку повыше
    } catch(_){
      throw ApiClienException(ApiClienExceptionType.Other);
    }
  }

  Future<String> _makeToken() async {
    String parser(dynamic json){
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }
    final result = _get("/authentication/token/new", parser, <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    PopularMovieResponse parser(dynamic json){
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _get(
      "/movie/popular",
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale
      });
    return result;
  }

  Future<PopularMovieResponse> searchMovie(int page, String locale, String query) async {
    PopularMovieResponse parser(dynamic json){
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _get(
        "/search/movie",
        parser,
        <String, dynamic>{
          'api_key': _apiKey,
          'page': page.toString(),
          'language': locale,
          'query': query,
        });
    return result;
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String requestToken}) async {
    String parser(dynamic json){
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    final result = _post(
      "/authentication/token/validate_with_login",
      parameters,
      parser,
      <String, dynamic>{'api_key': _apiKey}
    );
    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {

    String parser(dynamic json){
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = json['session_id'] as String;
      return sessionId;
    }
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };
    final result = _post(
        "/authentication/session/new",
        parameters,
        parser,
        <String, dynamic>{'api_key': _apiKey}
    );
    return result;
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if(response.statusCode == 401){
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if(code == 30){
        throw ApiClienException(ApiClienExceptionType.Auth);
      }else{
        throw ApiClienException(ApiClienExceptionType.Other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
