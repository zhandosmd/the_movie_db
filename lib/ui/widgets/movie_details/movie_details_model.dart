import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/api_client/api_client_exception.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier{
  final _sessionDataProvider = SessionDataProvider();
  final _movieApiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();

  final int movieId;
  bool _isFavourite = false;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;
  Future<void>? Function()? onSessionExpired;

  MovieDetailsModel(this.movieId);

  MovieDetails? get movieDetails => _movieDetails;
  bool get isFavourite => _isFavourite;

  String stringFromDate(DateTime? date) => date!=null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if(_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails();
  }

  Future<void> loadDetails() async{
    try{
      _movieDetails = await _movieApiClient.movieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if(sessionId != null){
        _isFavourite = await _movieApiClient.movieStates(movieId, sessionId);
      }
      notifyListeners();
    }on ApiClienException catch (e){
      _handleApiClientException(e);
    }
  }

  Future<void> markAsFavourite() async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();

    if(accountId == null || sessionId == null) return;

    _isFavourite = !_isFavourite;
    notifyListeners();
    try{
      await _accountApiClient.markAsFavourite(
          accountId: accountId,
          sessionId: sessionId,
          mediaType: MediaType.movie,
          mediaId: movieId,
          isFavourite: _isFavourite
      );
    }on ApiClienException catch (e){
      _handleApiClientException(e);
    }
  }

  void _handleApiClientException(ApiClienException exception) {
    switch(exception.type){
      case ApiClienExceptionType.sessionExpired:
        onSessionExpired?.call();
      break;
    default:
      print(exception);
    }
  }
}