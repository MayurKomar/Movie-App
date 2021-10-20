import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'movies_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  List<Movies> _movies = [];

  Future<void> getMovies(String movieName) async {
    var response = await http.get(
        Uri.parse('https://www.omdbapi.com/?s=$movieName&apikey=908215c3&'));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List list = result['Search'];

      for (int temp = 0; temp < list.length; temp++) {
        Movies movie = Movies(
            posterUrl: list[temp]['Poster'],
            title: list[temp]['Title'],
            year: list[temp]['Year'],
            movieId: list[temp]['imdbID']);
        _movies.add(movie);
        notifyListeners();
      }
    }
  }

  List<Movies> get moviesList => _movies;
}
