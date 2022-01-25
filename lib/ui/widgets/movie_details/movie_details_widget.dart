import 'package:flutter/material.dart';
import 'package:the_movie_db/Library/Widgets/Inherited/provider.dart';

import 'movie_details_main_info_widget.dart';
import 'movie_details_main_screen_cast_widget.dart';
import 'movie_details_model.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    NotifierProvider.read<MovieDetailsModel>(context)?.setupLocale(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

//вынесли в отдельный класс уотч, чтобы при изменение не перегружать весь экран
class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =  NotifierProvider.watch<MovieDetailsModel>(context);
    return Text(model?.movieDetails?.title ?? 'Загрузка...');
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.movieDetails;
    if(movieDetails == null) return const Center(child: CircularProgressIndicator(color: Colors.white,));

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: const [
        MovieDetailsMainInfoWidget(),
        SizedBox(height: 30,),
        MovieDetailsMainScreenCastWidget()
      ],
    );
  }
}

