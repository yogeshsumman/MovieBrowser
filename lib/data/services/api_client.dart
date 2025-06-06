//api_client.dart

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// import '../../core/app_constants.dart';
import '../model/movie.dart';
import '../model/search_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'http://www.omdbapi.com/')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/')
  Future<SearchResponse> searchMovies(
    @Query('s') String query,
    @Query('page') int page,
    @Query('apikey') String apiKey,
  );

  @GET('/')
  Future<Movie> getMovieDetails(
    @Query('i') String imdbId,
    @Query('plot') String plot,
    @Query('apikey') String apiKey,
  );
}