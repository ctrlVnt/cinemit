class Showtimes {
  final String day;
  final List<Cinema> theaters;
  bool isExpanded = false;

  Showtimes({
    required this.day,
    required this.theaters,
  });

  factory Showtimes.fromJson(Map<String, dynamic> json) {
    List<Cinema> cinemas = [];

    if (json['theaters'] != null) {
      cinemas = (json['theaters'] as List).map((cinemaJson) => Cinema.fromJson(cinemaJson)).toList();
    }

    String dayFormatted = json['day'].replaceFirst(RegExp(r'\d'), ' ${RegExp(r'\d').stringMatch(json['day'])}');

    return Showtimes(
      day: dayFormatted,
      theaters: cinemas,
    );
  }
}

class Cinema{
  final String name;
  final String link;
  final String distance;
  final String address;
  final List<Showing> show;

  Cinema({
    required this.name,
    required this.link,
    required this.distance,
    required this.address,
    required this.show,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    List<Showing> showList = (json['showing'] as List).map((showJson) => Showing.fromJson(showJson)).toList();
    return Cinema(
      name: json['name'],
      link: json['link'],
      distance: json['distance'],
      address: json['address'],
      show: showList,
    );
  }
}

class Showing {
  final List<String> time;

  Showing({required this.time, required type});

  factory Showing.fromJson(Map<String, dynamic> json) {

    ///Exclude 3D type to fix bug - need a solution
    if (json['type'] == '3D') {
      return Showing(time: [], type: json['type']);
    }

    List<String> times = (json['time'] as List).map((time) => time.toString()).toList();

    return Showing(
      time: times,
      type: json['type'],
    );
  }
}