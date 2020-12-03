class Spot {
  String id;
  String name;
  PTime startTime;
  PTime endTime;
  PTime maxDuration;
  double lat;
  double lng;
  int sector;
  double pricePerHour;

  Spot(
      {this.id,
      this.name,
      this.startTime,
      this.endTime,
      this.maxDuration,
      this.lat,
      this.lng,
      this.sector,
      this.pricePerHour});

  factory Spot.fromJson(Map<String, dynamic> map) {
    return Spot(
      id: map['_id'],
      name: map['name'],
      startTime:
          (map["startTime"] != null && map["startTime"] is Map<String, dynamic>)
              ? PTime.fromJson(map["startTime"])
              : PTime.initial(),
      endTime:
          (map["endTime"] != null && map["endTime"] is Map<String, dynamic>)
              ? PTime.fromJson(map["endTime"])
              : PTime.initial(),
      maxDuration: (map["maxDuration"] != null &&
              map["maxDuration"] is Map<String, dynamic>)
          ? PTime.fromJson(map["maxDuration"])
          : PTime.initial(),
      lat: map['location']['lat'].toDouble(),
      lng: map['location']['long'].toDouble(),
      sector: map['sector'],
      pricePerHour: map['pricePerHour'].toDouble(),
    );
  }

  static List<Spot> parseList(map) {
    var list = map['spots'] as List;
    return list.map((item) => Spot.fromJson(item)).toList();
  }

  Spot.initial()
      : id = '',
        name = '',
        startTime = null,
        endTime = null,
        lat = 0,
        lng = 0,
        sector = 0;
}

class PTime {
  int hours;
  int minutes;

  PTime({this.hours, this.minutes});

  factory PTime.fromJson(Map<String, dynamic> map) {
    return PTime(
      hours: map['hours'],
      minutes: map['minutes'],
    );
  }

  PTime.initial()
      : hours = 0,
        minutes = 0;

  @override
  String toString() {
    var h = hours < 10 ? '0$hours' : '$hours';
    var m = minutes < 10 ? '0$minutes' : '$minutes';

    return '$h:$m';
  }
}
