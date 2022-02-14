import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/api_client/image_downloader.dart';
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
    final scoreData = context.select((MovieDetailsModel vm) => vm.data.scoreData);
    final trailerKey = scoreData.trailerKey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () {}, child: Row(
          children: [
            Text('${scoreData.voteAverage}', style: const TextStyle(fontSize: 20),),
            const SizedBox(width: 10,),
            const Text('User Score'),
          ],
        )),
        Container(
          width: 1,
          height: 15,
          color: Colors.grey,
        ),
        if (trailerKey != null)TextButton(
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
        ))
      ],
    );
  }
}


class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary = context.select((MovieDetailsModel vm) => vm.data.summary);
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          summary,
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
    final crewChunks = context.select((MovieDetailsModel vm) => vm.data.peopleData);
    if(crewChunks.isEmpty) return const SizedBox.shrink();
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
  final List<MovieDetailsMoviePeopleData> employes;

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
  final MovieDetailsMoviePeopleData employee;

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






