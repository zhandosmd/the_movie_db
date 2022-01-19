import 'package:flutter/material.dart';
import 'package:the_movie_db/Library/Widgets/Inherited/provider.dart';
import 'package:the_movie_db/domain/data_providers/session_data_prodiver.dart';
import 'package:the_movie_db/ui/widgets/main_screen/main_screen_model.dart';
import 'package:the_movie_db/ui/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;

  void onSelectTab(int index) {
    if (_selectedTab == index) return;

    _selectedTab = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MainScreenModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
      ),
      body: IndexedStack( // хранить все виджеты на памяти тем самым сохраняя стейт
        index: _selectedTab,
        children: [
          GestureDetector(
            onTap: (){
              SessionDataProvider().setSessionId(null);
            },
            child: Center(child: const Text('Новости'))
          ),
          MovieListWidget(),
          const Text('Сериалы'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: onSelectTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Новости'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_filter), label: 'Фильмы'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Сериалы'),
        ],
      ),
    );
  }
}
