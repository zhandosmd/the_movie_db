import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/api_client/api_client_exception.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/domain/entity/movie_details.dart';
import 'package:the_movie_db/domain/services/auth_service.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class MovieDetailsPosterData{
  final String? backdropPath;
  final String? posterPath;
  final IconData favoriteIcon;

  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.favoriteIcon = Icons.favorite_border,
  });
}

class MovieDetailsMovieNameData{
  final String title;
  final String year;

  MovieDetailsMovieNameData({required this.title, required this.year});
}

class MovieDetailsData{
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsMovieNameData nameData = MovieDetailsMovieNameData(title: '', year: '');
}

class MovieDetailsModel extends ChangeNotifier{
  final _authService = AuthService();
  final _sessionDataProvider = SessionDataProvider();
  final _movieApiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();

  final int movieId;
  final data = MovieDetailsData();
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
    updateData(null, false);
    await loadDetails(context);
  }

  Future<void> loadDetails(BuildContext context) async{
    try{
      _movieDetails = await _movieApiClient.movieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if(sessionId != null){
        _isFavourite = await _movieApiClient.movieStates(movieId, sessionId);
      }
      updateData(_movieDetails, _isFavourite);
      notifyListeners();
    }on ApiClienException catch (e){
      _handleApiClientException(e, context);
    }
  }

  void updateData(MovieDetails? details, bool isFavourite){
    data.title = details?.title ?? 'Loading...';
    data.isLoading = details == null;
    if(details == null){
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    final iconData = isFavourite ? Icons.favorite : Icons.favorite_outline;
    data.posterData = MovieDetailsPosterData(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      favoriteIcon: iconData
    );
    var year = details.releaseDate?.year.toString();
    year = (year != null) ? ' ($year)' : '';
    data.nameData = MovieDetailsMovieNameData(
      title: details.title, year: year
    );
    notifyListeners();
  }

  Future<void> toggleFavorite(BuildContext context) async {
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
      _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(ApiClienException exception, BuildContext context) {
    switch(exception.type){
      case ApiClienExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
      break;
    default:
      print(exception);
    }
  }
}