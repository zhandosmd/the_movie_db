import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    Future.microtask(() =>
      context.read<MovieDetailsModel>().setupLocale(context),
    );
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
    final title = context.select((MovieDetailsModel vm) => vm.data.title);
    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =  context.select((MovieDetailsModel vm) => vm.data.isLoading);
    if(isLoading) return const Center(child: CircularProgressIndicator(color: Colors.white,));

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

