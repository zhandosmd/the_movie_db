import 'package:flutter/material.dart';

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
        _SummaryWidget(),
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
    return const Text('An elite Navy SEAL uncovers an international '
        'conspiracy while seeking justice for the murder of his pregnant wife.', style: TextStyle(fontSize:16, color: Colors.white),);
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
    return Stack(
      children: [
        Image.asset('images/details_back.jpg'),
        Positioned(
          top: 20,
          left: 20,
          bottom: 20,
          child: Image.asset('images/details_front.jpg')
        ),
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: "Tom Clancy's Without Remorse",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17
            )),
          TextSpan(
            text: "(2021)",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16
            )),
        ]
      ));
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: (){}, child: Row(
          children: const [
            Icon(Icons.score_rounded),
            SizedBox(width: 10,),
            Text('User Score'),
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
    return const ColoredBox(
      color: Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: Text(
          'R 04/29/2021 (US) 1h 49m Action, Thriller, War',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
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




