import 'package:the_movie_db/configuration/configuration.dart';

import 'network_client.dart';

enum MediaType{ movie, tv }

extension MediaTypeAsString on MediaType{
  String asString(){
    switch (this){
      case MediaType.movie: return 'movie';
      case MediaType.tv: return 'tv';
    }
  }
}

class AccountApiClient{
  final _networkClient = NetworkClient();

  Future<int> getAccountInfo(String sessionId) async {
    int parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = jsonMap['id'] as int;
      return response;
    }

    final result =
    _networkClient.get("/account", parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionId,
    });
    return result;
  }

  Future<int> markAsFavourite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavourite,
  }) async {
    int parser(dynamic json){
      return 1;
    }

    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': isFavourite,
    };
    final result = _networkClient.post("/account/$accountId/favorite", parameters, parser,
        <String, dynamic>{
          'api_key': Configuration.apiKey,
          'session_id': sessionId,
        });
    return result;
  }
}