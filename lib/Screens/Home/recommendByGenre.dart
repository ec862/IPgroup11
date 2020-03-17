import 'dart:math';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Services/DatabaseServices.dart';

class RecommendByGenre {
  static List action = [
    "tt0848228",
    "tt0095016",
    "tt0468569",
    "tt2911666",
    "tt0425112",
    "tt1899353",
    "tt0082971",
    "tt0057076",
    "tt1074638",
    "tt1392190",
    "tt1229238",
    "tt0266697",
    "tt0112442",
    "tt0172495",
    "tt2015381",
    "tt0371746",
    "tt3890160"
  ];
  static List comedy = [
    "tt0071853",
    "tt0079470",
    "tt0080339",
    "tt0365748",
    "tt0443453",
    "tt0088258",
    "tt0087332",
    "tt1232829",
    "tt0942385",
    "tt1341167",
    "tt0096928",
    "tt0357413",
    "tt0118715",
    "tt0109686",
    "tt0057012",
    "tt0071230",
    "tt0017925",
    "tt1190536",
    "tt0374900",
  ];
  static List family = [
    "tt0114709",
    "tt0266543",
    "tt0083866",
    "tt0099785",
    "tt1490017",
    "tt0241527",
    "tt0892769",
    "tt0058331",
    "tt4633694",
    "tt1109624",
    "tt0118689",
    "tt0032138",
    "tt0107614",
    "tt0087538",
    "tt0477347",
    "tt0363771",
    "tt0048960",
    "tt0113497",
    "tt2283362",
    "tt0118998"
  ];
  static List thriller = [
    "tt5052448",
    "tt0167404",
    "tt1130884",
    "tt0477348",
    "tt1375666",
    "tt0114814",
    "tt0947798",
    "tt6644200",
    "tt0144084",
    "tt1340800",
    "tt0049470",
    "tt0053125",
    "tt0105236",
    "tt0102926",
    "tt0033870",
    "tt0443706",
    "tt0106977",
    "tt0119488",
    "tt0067116"
  ];
  static List horror = [
    "tt0081505",
    "tt1259521",
    "tt1396484",
    "tt4972582",
    "tt0072271",
    "tt0070047",
    "tt0054215",
    "tt0013442",
    "tt0078748",
    "tt0087800",
    "tt0185937",
    "tt0117571",
    "tt0178868",
    "tt0084516"
  ];

  //static HashMap movieGenres = new Map();
  static Map movieGenres = {
    'action': action,
    'comedy': comedy,
    'thriller': thriller,
    'horror': horror,
    'family': family
  };

  static Future getMovies(String genre, int numberOfMovies) async {
    Random rand = new Random(DateTime
        .now()
        .millisecondsSinceEpoch);
    List moviesRecs = [];
    List temp = movieGenres[genre];
    Set picked = new Set();
    print(temp.length);
    while (picked.length < numberOfMovies) {
      int index = rand.nextInt(temp.length);
      if (!picked.contains(index)) {
        picked.add(index);
        MovieDetails a = await DatabaseServices(User.userdata.uid)
            .getMovieDetails(id: temp[index]);
        RecommendedMoviesDetails b = RecommendedMoviesDetails(
            movie_id: temp[index],
            movie_name: a.name,
            rec_by: "f4IggrkZ5pE5mQsjVjl7");
        moviesRecs.add(b);
      }
    }
    return moviesRecs;
  }
}
