import 'package:parkspace/data/Model/spot.dart';

class Reservation {
  String id;
  PTime duration;
  Spot spot;
  String licencePlate;
  bool fullDay;
  bool hasEnded;
  double cost;
  String startTime;
  String endTime;

  Reservation(
      {this.id,
      this.duration,
      this.spot,
      this.licencePlate,
      this.fullDay,
      this.hasEnded,
      this.cost,
      this.startTime,
      this.endTime});

  factory Reservation.fromJson(Map<String, dynamic> map) {
    return Reservation(
      id: map['_id'],
      duration:
          (map["duration"] != null && map["duration"] is Map<String, dynamic>)
              ? PTime.fromJson(map["duration"])
              : PTime.initial(),
      spot: (map["spot"] != null && map["spot"] is Map<String, dynamic>)
          ? Spot.fromJson(map["spot"])
          : Spot.initial(),
      licencePlate: map['licencePlate'],
      fullDay: map['fullDay'],
      hasEnded: map['hasEnded'],
      cost: map['cost'].toDouble(),
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }

  static List<Reservation> parseList(map) {
    var list = map['reservations'] as List;
    return list.map((item) => Reservation.fromJson(item)).toList();
  }

  String getReservationDate() {
    var date = DateTime.parse(startTime).toUtc();
    return '${parseNumberForTwoDigits(date.day)}.${parseNumberForTwoDigits(date.month)}.${date.year}';
  }

  String getReservationTime() {
    var startDate = DateTime.parse(startTime).toUtc();
    var endDate = DateTime.parse(endTime).toUtc();

    return '${parseNumberForTwoDigits(startDate.hour)}:${parseNumberForTwoDigits(startDate.minute)} - ${parseNumberForTwoDigits(endDate.hour)}:${parseNumberForTwoDigits(endDate.minute)}';
  }

  String getReservationEndTime() {
    var endDate = DateTime.parse(endTime).toUtc();

    return '${parseNumberForTwoDigits(endDate.hour)}:${parseNumberForTwoDigits(endDate.minute)}';
  }

  String parseNumberForTwoDigits(int number) {
    return number < 10 ? '0$number' : '$number';
  }

  static parseFromJson(response) {}
}
