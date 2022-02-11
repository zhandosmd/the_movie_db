import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_model.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/ui/widgets/loader/loader_view_model.dart';
import 'package:the_movie_db/ui/widgets/loader/loader_widget.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_model.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_model.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_trailer/movie_trailer_widget.dart';

class ScreenFactory {
  Widget makeLoader(){
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
      lazy: false, // our viewModel will created before the call
    );
  }

  Widget makeAuth(){
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget()
    );
  }

  Widget makeMainScreen(){
    return const MainScreenWidget();
  }

  Widget makeMovieDetails(int movieId){
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsModel(movieId),
      child: const MovieDetailsWidget()
    );
  }
  Widget makeMovieTrailer(String youtubeKey){
    return MovieTrailerWidget(youtubeKey: youtubeKey,);
  }

  Widget makeNewsList(){
    return GestureDetector(
      onTap: (){
        SessionDataProvider().deleteSessionId();
      },
      child: const Center(child: Text('Новости'))
    );
  }

  Widget makeMovieList(){
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget()
    );
  }

  Widget makeTVShowList(){
    return const Text('Сериалы');
  }
}