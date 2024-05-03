import 'package:sevenapplication/core/models/user.dart';

class Rating {
  String objectId;
  User jobber;
  User worker;
  int rating;
  Rating(
      {required this.objectId,
      required this.jobber,
      required this.worker,
      required this.rating});
  factory Rating.fromJson(json) {
    return Rating(
        objectId: json['objectId'],
        jobber: User.fromJson(json['jobber']),
        worker: User.fromJson(json['worker']),
        rating: json['rating']);
  }
}
