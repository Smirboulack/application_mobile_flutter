import 'dart:ui';

class Mission {
  final int id;
  final String title, address;
  final double price;
  final String temps;
  final entrepriseName;
  DateTime startDate;
  DateTime endDate;

  Mission(
      {required this.id,
      required this.title,
      required this.address,
      required this.price,
      required this.temps,
      required this.entrepriseName,
      required this.startDate,
      required this.endDate});
}
