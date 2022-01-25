import 'package:flutter/material.dart';
import 'package:the_movie_db/Library/Widgets/Inherited/provider.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';

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
        _PeopleWidget()

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
    final overview = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails?.overview ?? '';
    return Text(overview, style: const TextStyle(fontSize:16, color: Colors.white),);
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          (backdropPath!=null)
            ? Image.network(ApiClient.imageUrl(backdropPath))
            : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: (posterPath!=null)
                ? Image.network(ApiClient.imageUrl(posterPath))
                : const SizedBox.shrink()
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = (year != null) ? ' ($year)' : '';

    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: model?.movieDetails?.title ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17
              )),
            TextSpan(
              text: year,
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
    var voteAverage = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails?.voteAverage ?? 0;
    // voteAverage = voteAverage * 10;
    voteAverage.toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: (){}, child: Row(
          children: [
            // Icon(Icons.score_rounded),
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
        TextButton(onPressed: (){}, child: Row(
          children: const [
            Icon(Icons.play_arrow),
            SizedBox(width: 10,),
            Text('Play Trailer'),
          ],
        )),
      ],
    );
  }
}


class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if(model==null) return const SizedBox.shrink();
    var texts = <String>[];
    final releaseDate = model.movieDetails?.releaseDate;
    if(releaseDate != null){
      texts.add(model.stringFromDate(releaseDate));
    }
    final productionCountries = model.movieDetails?.productionCountries;
    if(productionCountries != null && productionCountries.isNotEmpty){
      texts.add('(${productionCountries.first.iso})');
    }
    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    final genres = model.movieDetails?.genres;
    if(genres != null){
      var genresNames = <String>[];
      for(var genre in genres){
        genresNames.add(genre.name);
      }
      texts.add(genresNames.join(', '));
    }
    // 'R $releaseDateString (US) 1h 49m Action, Thriller, War',
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
    const nameStyle = TextStyle(
        fontSize: 16,
        color: Colors.white
    );
    const jobStyle = TextStyle(
        fontSize: 16,
        color: Colors.white
    );
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Stefano Sollima', style: nameStyle,),
                Text('Director', style: jobStyle),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Tom Clancy', style: nameStyle,),
                Text('Novel', style: jobStyle),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Stefano Sollima', style: nameStyle,),
                Text('Director', style: jobStyle),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Tom Clancy', style: nameStyle,),
                Text('Novel', style: jobStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }
}




