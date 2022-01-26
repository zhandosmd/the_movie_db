import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/widgets/app/my_app.dart';
import 'package:the_movie_db/ui/widgets/app/my_app_model.dart';

import 'Library/Widgets/Inherited/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.checkAuth();
  final app = const MyApp();
  final widget  = Provider( model: model, child: app);
  runApp(widget);
}