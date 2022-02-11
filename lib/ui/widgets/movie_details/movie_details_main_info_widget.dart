import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/api_client/image_downloader.dart';
import 'package:the_movie_db/domain/entity/movie_details_credits.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

import 'movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: _MovieNameWidget()),
        ),
        _ScoreWidget(),
        Center(child: _SummaryWidget()),
        Padding(
          padding: EdgeInsets.all(10),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: _DescriptionWidget(),
        ),
        SizedBox(height: 30,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _PeopleWidget(),
        )
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview = context
      .select((MovieDetailsModel vm) => vm.data.overview);
    return Text(
      overview, style: const TextStyle(fontSize: 16, color: Colors.white),);
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Overview',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: Colors.white
      )
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    final posterData = context
        .select((MovieDetailsModel vm) => vm.data.posterData);
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          if(backdropPath != null)
            Image.network(ImageDownloader.imageUrl(backdropPath)),
          if((posterPath != null))
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image.network(ImageDownloader.imageUrl(posterPath))
            ),
          Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: (){
                  model.toggleFavorite(context);
                },
                icon: Icon(posterData.favoriteIcon),
              )
          )
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameData = context.select((MovieDetailsModel vm) => vm.data.nameData);
    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
                text: nameData.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                )),
            TextSpan(
                text: nameData.year,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                )),
          ]
        )),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails = context.select((MovieDetailsModel vm) => vm.movieDetails);

    var voteAverage = movieDetails?.voteAverage ?? 0;
    voteAverage.toInt();
    final videos = movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () {}, child: Row(
          children: [
            Text('$voteAverage', style: const TextStyle(fontSize: 20),),
            const SizedBox(width: 10,),
            const Text('User Score'),
          ],
        )),
        Container(
          width: 1,
          height: 15,
          color: Colors.grey,
        ),
        (trailerKey != null) ? TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(
                    MainNavigationRouteNames.movieTrailer,
                    arguments: trailerKey
                ),
            child: Row(
              children: const [
                Icon(Icons.play_arrow),
                SizedBox(width: 10,),
                Text('Play Trailer'),
              ],
            )) : const SizedBox.shrink(),
      ],
    );
  }
}


class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final movieDetails = context.select((MovieDetailsModel vm) => vm.movieDetails);

    var texts = <String>[];
    final releaseDate = movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final productionCountries = movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }
    final runtime = movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    final genres = movieDetails?.genres;
    if (genres != null) {
      var genresNames = <String>[];
      for (var genre in genres) {
        genresNames.add(genre.name);
      }
      texts.add(genresNames.join(', '));
    }
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          texts.join(' '),
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var crew = context.select((MovieDetailsModel vm) => vm.movieDetails?.credits.crew);

    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = (crew.length > 4) ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }
    return Column(
      children: crewChunks
          .map((chunk) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _PeopleWidgetsRow(employes: chunk,),
          ))
          .toList(),
    );
  }
}

class _PeopleWidgetsRow extends StatelessWidget {
  final List<Employee> employes;

  const _PeopleWidgetsRow({Key? key, required this.employes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: employes
          .map((employee) => _PeopleWidgetsRowItem(employee: employee,))
          .toList(),
    );
  }
}

class _PeopleWidgetsRowItem extends StatelessWidget {
  final Employee employee;

  const _PeopleWidgetsRowItem({Key? key, required this.employee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
        fontSize: 16,
        color: Colors.white
    );
    const jobStyle = TextStyle(
        fontSize: 16,
        color: Colors.white
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle,),
          Text(employee.job, style: jobStyle),
        ],
      ),
    );
  }
}






