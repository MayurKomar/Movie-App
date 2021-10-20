class Movies {
  Movies({required this.posterUrl,required this.title,required this.year, required this.movieId});

  String title;
  String year;
  String posterUrl;
  String movieId;

  factory Movies.fromJson(Map<String,dynamic> json){
    return Movies(posterUrl: json['Poster'], title: json['Title'], year: json['Year'],movieId: json['imdbID']);
  }

}