import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/theme/app_colors.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_model.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => AuthProvider(
          model: AuthModel(),
          child: const AuthWidget()
        ),
        '/main_screen': (context) => const MainScreenWidget(),
      },
      // onGenerateRoute: (RouteSettings settings){
      //   return MaterialPageRoute<void>(builder: (context){
      //     return const Scaffold(
      //       body: Center(
      //         child: Text('Произошла ошибка навигации'),
      //       ),
      //     );
      //   });
      // },
    );
  }
}