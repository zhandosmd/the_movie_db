import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier{
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  final int movieId;
  bool _isFavourite = false;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;

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
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    if(sessionId != null){
      _isFavourite = await _apiClient.movieStates(movieId, sessionId);
    }
    notifyListeners();
  }

  Future<void> markAsFavourite() async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();

    if(accountId == null || sessionId == null) return;

    _isFavourite = !_isFavourite;
    notifyListeners();
    _apiClient.markAsFavourite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.Movie,
        mediaId: movieId,
        isFavourite: _isFavourite
    );
  }
}