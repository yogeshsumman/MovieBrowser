import 'package:flutter/material.dart';
import './controller/movie_controller.dart' as movie_controller; // Alias to avoid conflict
import 'data/repositories/movie_repository.dart';
import 'data/services/api_service.dart';
import './presentation/screens/home_screen.dart';
import 'theme/theme.dart';



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = movie_controller.MovieController(MovieRepository(ApiService()));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browser',
      theme: AppTheme.lightTheme,
      home: HomeScreen(controller: controller),
    );
  }
}