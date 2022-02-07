import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/Library/paginator.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/entity/movie.dart';
import 'package:the_movie_db/domain/entity/popular_movie_response.dart';
import 'package:the_movie_db/domain/services/movie_service.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class MovieListRowData{
  final int id;
  final String? posterPath;
  final String title;
  final String overview;
  final String releaseDate;

  MovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.overview,
    required this.releaseDate
  });
}

class MovieListViewModel extends ChangeNotifier{
  final _movieService = MovieService();
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;
  Timer? searchDebounce;
  String _locale = '';

  var _movies = <MovieListRowData>[];
  String? _searchQuery;
  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;

  bool get isSearchMode{
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  MovieListViewModel(){
    _popularMoviePaginator = Paginator<Movie>((page) async{
      final result = await _movieService.popularMovie(page, _locale);
      return PaginatorLoadResult(
        data: result.movies,
        currentPage: result.page,
        totalPage: result.totalPages);
    });
    _searchMoviePaginator = Paginator<Movie>((page) async{
      final result = await _movieService.searchMovie(page, _locale, _searchQuery ?? '');
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if(_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await  _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }



  Future<void> _loadNextPage() async{
    if(isSearchMode){
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
    } else{
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  MovieListRowData _makeRowData(Movie movie){
    final releaseDate = movie.releaseDate;
    final releaseDateTitle = releaseDate!=null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
      overview: movie.overview,
      releaseDate: releaseDateTitle,
      id: movie.id,
      posterPath: movie.posterPath,
      title: movie.title
    );
  }

  void onMovieTap(BuildContext context, int index){
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id
    );
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if(_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;

      _movies.clear();
      if(isSearchMode){
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieIndex(int index){
    if(index < _movies.length - 1) return;
    _loadNextPage();
  }
}