import 'package:the_movie_db/configuration/configuration.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/domain/entity/popular_movie_response.dart';
import 'package:the_movie_db/domain/local_entity/movie_details_local.dart';

class MovieService{
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(page, locale, Configuration.apiKey);

  Future<PopularMovieResponse> searchMovie(int page, String locale, String query) async =>
      _movieApiClient.searchMovie(page, locale, query, Configuration.apiKey);

  Future<MovieDetailsLocal> loadDetails({required int movieId, required String locale}) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavourite = false;
    if (sessionId != null) {
      isFavourite = await _movieApiClient.movieStates(movieId, sessionId);
    }
    return MovieDetailsLocal(isFavorite: isFavourite, details: movieDetails);
  }

  Future<void> updateFavorite({required int movieId, required bool isFavorite}) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();

    if (accountId == null || sessionId == null) return;
    await _accountApiClient.markAsFavourite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.movie,
        mediaId: movieId,
        isFavourite: isFavorite);
  }
}