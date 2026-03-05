import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/showtimes.dart';
import '../utils/apikey.dart';

Future<List<Showtimes>> fetchShowtimes(String film, String location) async {

  if (location.toLowerCase() == 'milano') {
    location = 'Milan';
  }

  String encoded = Uri.encodeComponent(film);

  final url ='https://serpapi.com/search.json?q=$encoded+theater&location=$location,+France&hl=fr&gl=fr&api_key=$SERP_API_KEY';

  try {
    final response = await http.get(Uri.parse(url));

    List<Showtimes> allShowtimes = [];

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['showtimes'] ?? [];
      allShowtimes.addAll(data.map((showJson) => Showtimes.fromJson(showJson)));
    } else {
      debugPrint("Error fetching from one source: ${response.statusCode}");
    }

    return allShowtimes;

  } catch (e) {
    debugPrint("Exception fetching cinema list: $e");
    return [];
  }
}