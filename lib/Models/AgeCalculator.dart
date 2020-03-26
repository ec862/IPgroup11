import 'package:cloud_firestore/cloud_firestore.dart';

class AgeCalculator{
  static bool canRecommendTo({String rating, Timestamp dob}){
    Timestamp now = Timestamp.fromDate(DateTime.now());
    int dif = now.millisecondsSinceEpoch - dob.millisecondsSinceEpoch;
    int age = 31557600000 * _getAge(rating);
    print(age);
    print(dif);
    return (dif >= age);
  }

  static int _getAge(String rating){
    try {
      Map ages = Map();
      ages['G'] = 0;
      ages['PG'] = 0;
      ages['PG-13'] = 0;
      ages['R'] = 15;
      ages['NC-17'] = 18;
      ages['Not Rated'] = 0;

      dynamic mp =  ages[rating];
      if (mp == null)
        return 18;

      return mp;
    } catch (e) {
      return 18;
    }
  }
}
