import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';
import 'package:the_movie_db/ui/theme/app_colors.dart';
import 'package:the_movie_db/ui/widgets/app/my_app_model.dart';

class MyApp extends StatelessWidget {
  final MyAppModel model;
  static final mainNavigation = MainNavigation(); // static потому чтобы не пересоздавалось, когда виджет заново создается
  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
          centerTitle: true,
          elevation: 0
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey
        )
      ),
      initialRoute: mainNavigation.initialRoute(model.isAuth),
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}