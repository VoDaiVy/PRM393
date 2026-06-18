import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../models/weather.dart';
import '../models/show.dart';
import '../models/post.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  // --- POSTS APP (Lab 8.1 - 8.4) ---
  static const String postsBaseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> getPosts() async {
    final response = await client.get(Uri.parse('$postsBaseUrl/posts'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts. Status code: ${response.statusCode}');
    }
  }

  Future<Post> createPost(String title, String body) async {
    final response = await client.post(
      Uri.parse('$postsBaseUrl/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'body': body,
        'userId': 1,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post. Status code: ${response.statusCode}');
    }
  }

  // --- WEATHER APP ---
  Future<List<City>> searchCities(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5');
    final response = await client.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('results') && data['results'] != null) {
        List<dynamic> results = data['results'];
        return results.map((json) => City.fromJson(json)).toList();
      }
      return []; // No results found
    } else {
      throw Exception('Failed to search cities.');
    }
  }

  Future<Weather> getCurrentWeather(double lat, double lon) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&timezone=auto');
    
    final response = await client.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch weather data.');
    }
  }

  // --- MOVIE APP (TVMaze API) ---
  Future<List<Show>> fetchShows() async {
    final url = Uri.parse('https://api.tvmaze.com/shows');
    final response = await client.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Return top 50 shows for performance
      return data.take(50).map((json) => Show.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shows.');
    }
  }
}
