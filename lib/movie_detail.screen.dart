import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatefulWidget {
  MovieDetailScreen({required this.movieid, Key? key}) : super(key: key);

  String movieid;

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  String title = '';
  String moviePosterUrl = '';
  String movieGenre = '';
  String imdRating = '';
  String rtRating = '';
  String metaRating = '';
  String releaseYear = '';
  String country = '';
  String runTime = '';
  String language = '';
  String plot = '';
  String actors = '';
  String directors = '';
  String writers = '';
  List<String> allDirectors = [];
  List<String> allActors = [];
  List<String> allWriters = [];
  Future<void> getMovieDetails(String movieId) async {
    final response = await http
        .get(Uri.parse('https://www.omdbapi.com/?i=$movieId&apikey=908215c3&'));
    final result = jsonDecode(response.body);
    title = result['Title'];
    setState(() {
      moviePosterUrl = result['Poster'];
    });
    movieGenre = result['Genre'];
    imdRating = result['Ratings'][0]['Value'];
    rtRating = result['Ratings'][1]['Value'];
    metaRating = result['Ratings'][2]['Value'];
    releaseYear = result['Year'];
    country = result['Country'];
    runTime = result['Runtime'];
    language = result['Language'];
    plot = result['Plot'];
    actors = result['Actors'];
    allActors = actors.split(',');
    directors = result['Director'];
    allDirectors = directors.split(',');
    writers = result['Writer'];
    allWriters = writers.split(',');
  }

  @override
  void initState() {
    super.initState();
    getMovieDetails(widget.movieid);
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height / 1.5;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Theme.of(context).scaffoldBackgroundColor
                      ]),
                ),
                height: containerHeight,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    if (moviePosterUrl != '')
                      Container(
                        width: double.infinity,
                        child: Image.network(
                          moviePosterUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (moviePosterUrl == '')
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    Positioned(
                      left: 30,
                      top: 30,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage('assets/images/back.png'))),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 30,
                        top: containerHeight - 220,
                        child: Container(
                            width: 250,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    movieGenre,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ))),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttons('assets/images/download.png'),
                buttons('assets/images/fav.png'),
                buttons('assets/images/share.png')
              ],
            ),
            SizedBox(
              height: 20,
            ),
            detailsContainer([
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Icon(Icons.star),
                    Icon(Icons.star),
                    Icon(Icons.star),
                    Icon(Icons.star),
                    Icon(Icons.star),
                    Expanded(child: SizedBox()),
                    Text(imdRating,
                        style: TextStyle(color: Colors.white, fontSize: 17))
                  ],
                ),
              ),
              rating('Internet Movie Database', imdRating),
              rating('Rotten Tomatoes', rtRating),
              rating('Metacritic', metaRating),
              SizedBox(
                height: 20,
              )
            ]),
            detailsContainer([
              SizedBox(
                height: 25,
              ),
              iconWithText('assets/images/calendar.png', releaseYear),
              SizedBox(
                height: 15,
              ),
              iconWithText('assets/images/globe.png', country),
              SizedBox(
                height: 15,
              ),
              iconWithText('assets/images/clock.png', runTime),
              SizedBox(
                height: 15,
              ),
              iconWithText('assets/images/sound.png', language),
              SizedBox(
                height: 25,
              ),
            ]),
            detailsContainer([
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Plot',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '"$plot"',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: 35,
              ),
              chipList('Directors', allDirectors),
              SizedBox(
                height: 35,
              ),
              chipList('Actors', allActors),
              SizedBox(
                height: 35,
              ),
              chipList('Writers', allWriters)
            ]),
            SizedBox(height: 30,)
          ],
        ),
      ),
    ));
  }

  Widget chipList(String title, List<String> list) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 10,
            children: List.generate(
                list.length,
                (index) => Chip(
                      backgroundColor: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.7),
                      labelStyle: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.6)),
                      label: Text(list[index].toUpperCase()),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    )),
          ),
        )
      ],
    );
  }

  Widget iconWithText(String iconPath, String text) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          height: 20,
        ),
        SizedBox(
          width: 15,
        ),
        Text(text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ))
      ],
    );
  }

  Widget detailsContainer(List<Widget> widgetList) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgetList,
      ),
    );
  }

  Widget rating(String ratingName, String rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
              width: 200,
              child: Text(
                ratingName,
                style: TextStyle(color: Colors.white, fontSize: 17),
              )),
          Expanded(child: SizedBox()),
          Text(rating, style: TextStyle(color: Colors.white, fontSize: 17))
        ],
      ),
    );
  }

  Widget buttons(String imagePath) {
    return Container(
      height: 60,
      width: 60,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.1)),
      child: Image.asset(
        imagePath,
      ),
    );
  }
}
