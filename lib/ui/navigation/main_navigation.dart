import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/factories/screen_factory.dart';

abstract class MainNavigationRouteNames{
  static const loaderWidget = '/';
  static const auth = '/auth';
  static const mainScreen = '/main_screen';
  static const movieDetails = '/main_screen/movie_details';
  static const movieTrailer = '/main_screen/movie_details/movie_trailer';
}

class MainNavigation{
  static final _screenFactory = ScreenFactory();
  final routes = <String, Widget Function(BuildContext)>{
    // статичные, снизу с аргументами
    MainNavigationRouteNames.loaderWidget: (_) => _screenFactory.makeLoader(),
    MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuth(),
    MainNavigationRouteNames.mainScreen: (_) => _screenFactory.makeMainScreen(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(  // can re build, so we will lose model
          builder: (context) => _screenFactory.makeMovieDetails(movieId, context),
        );
      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(  // can re build, so we will lose model
          builder: (_) => _screenFactory.makeMovieTrailer(youtubeKey),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
  static void resetNavigation(BuildContext context){
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.loaderWidget,
        (route) => false
    );
  }
}