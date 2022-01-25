import 'package:flutter/material.dart';
import 'package:the_movie_db/Library/Widgets/Inherited/provider.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_model.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_model.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_model.dart';
import 'package:the_movie_db/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:the_movie_db/ui/widgets/movie_trailer/movie_trailer_widget.dart';

abstract class MainNavigationRouteNames{
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movie_details';
  static const movieTrailer = '/movie_details/movie_trailer';
}

class MainNavigation{
  String initialRoute(bool isAuth) => (isAuth)
      ?MainNavigationRouteNames.mainScreen
      :MainNavigationRouteNames.auth;

  final routes = <String, Widget Function(BuildContext)>{
    // статичные, снизу с аргументами
    MainNavigationRouteNames.auth: (context) => NotifierProvider(
        create: () => AuthModel(),
        child: const AuthWidget()
    ),
    MainNavigationRouteNames.mainScreen: (context) => NotifierProvider(
        create: () => MainScreenModel(),
        child: const MainScreenWidget()
    ),
  };

  Route<Object> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(  // can re build, so we will lose model
          builder: (context) => NotifierProvider(
            create: () => MovieDetailsModel(movieId)..setupLocale(context),
            child: const MovieDetailsWidget()
          ),
        );
      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(  // can re build, so we will lose model
          builder: (context) => MovieTrailerWidget(youtubeKey: youtubeKey,),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}