import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class Movie{
  final int id;
  final String imageName;
  final String title;
  final String time;
  final String description;

  Movie({
    required this.id,
    required this.imageName,
    required this.title,
    required this.time,
    required this.description
  });
}


class MovieListWidget extends StatefulWidget {

  MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final _movies = [
    Movie(
      id: 1,
      imageName: 'images/movie_1.jpg',
      title: 'Spider-Man: No Way Home',
      time: 'December 15, 2021',
      description: 'Peter Parker is unmasked and no longer able to separate his normal life .'
    ),
    Movie(
      id: 2,
      imageName: 'images/movie_1.jpg',
      title: 'Ghostbusters: Afterlife',
      time: 'December 15, 2021',
      description: 'Peter Parker is unmasked and no longer able to separate his normal life .'
    ),
    Movie(
      id: 3,
      imageName: 'images/movie_1.jpg',
      title: 'Encanto',
      time: 'December 15, 2021',
      description: 'Peter Parker is unmasked and no longer able to separate his normal life .'
    ),
    Movie(
      id: 4,
      imageName: 'images/movie_1.jpg',
      title: 'The Matrix Resurrections',
      time: 'December 15, 2021',
      description: 'Peter Parker is unmasked and no longer able to separate his normal life .'
    ),
    Movie(
      id: 5,
      imageName: 'images/movie_1.jpg',
      title: 'Venom: Let There Be Carnage',
      time: 'December 15, 2021',
      description: 'Peter Parker is unmasked and no longer able to separate his normal life .'
    ),
    Movie(
      id: 6,
      imageName: 'images/movie_1.jpg',
      title: 'Red Notice',
      time: 'December 15, 2021',
      description: 'Peter Parker is unmasked and no longer able to separate his normal life .'
    ),
  ];

  var _filteredMovies = <Movie>[];

  final _searchController = TextEditingController();

  void _searchMovies(){
    final query = _searchController.text;
    if(query.isNotEmpty){
      _filteredMovies = _movies.where((Movie movie){
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else{
      _filteredMovies = _movies;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _filteredMovies = _movies;
    _searchController.addListener(_searchMovies);
  }

  void _onMovieTap(int index){
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          itemCount: _filteredMovies.length,
          itemExtent: 163,
          itemBuilder: (context, index){
            final movie = _filteredMovies[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0,2)
                        )
                      ]
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        Image.asset(movie.imageName),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              const SizedBox(height: 20,),
                              Text(movie.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5,),
                              Text(movie.time,
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 20,),
                              Text(movie.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10,),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () => _onMovieTap(index),
                    ),
                  )
                ],
              ),
            );
          }
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: const OutlineInputBorder()
            ),
          ),
        )
      ],
    );
  }
}
