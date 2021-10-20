import 'package:assign/movie_detail.screen.dart';
import 'package:assign/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoviesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xff210F37),
            iconTheme: IconThemeData(color: Color(0xfff79e44)),
            fontFamily: 'Montserrat'),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MoviesProvider>(context);
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(children: [
                    SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      'assets/images/Frame.png',
                      height: 25,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (val) {
                          provider.moviesList.clear();
                          provider.getMovies('$val');
                        },
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search Movie',
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _controller.clear();
                      },
                      child: Image.asset(
                        'assets/images/cancel.png',
                        height: 25,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                  child: ListView(
                children: List.generate(
                  provider.moviesList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => MovieDetailScreen(movieid: provider.moviesList[index].movieId,)));
                    },
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      Stack(children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      '${provider.moviesList[index].posterUrl}'))),
                        ),
                        Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 7, top: 5, bottom: 5, right: 7),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                  ),
                                  Text(
                                    '8.2/10',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  )
                                ],
                              ),
                            ))
                      ]),
                      alignment(
                          Text(
                            provider.moviesList[index].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          true),
                      alignment(
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/clock.png',
                                height: 15,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                '2 hours 1 minute',
                                style: TextStyle(
                                  color: Color(0xfff79e44),
                                ),
                              )
                            ],
                          ),
                          false),
                      SizedBox(
                        height: 30,
                      )
                    ]),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    ));
  }

  Widget alignment(Widget child, bool vertPad) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: vertPad ? 10 : 0),
          child: child),
    );
  }
}
