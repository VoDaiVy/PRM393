import 'package:flutter/material.dart';
import '../models/city.dart';
import '../models/weather.dart';
import '../services/api_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  City? _selectedCity;
  Future<Weather>? _futureWeather;

  // Danh sách các thành phố gợi ý
  static const List<String> _suggestedCities = [
    'Hanoi',
    'Ho Chi Minh',
    'Da Nang',
    'Tokyo',
    'London',
    'New York',
  ];

  void _searchAndFetchWeather([String? cityName]) async {
    final query = cityName ?? _searchController.text.trim();
    if (query.isEmpty) return;

    if (cityName != null) {
      _searchController.text = cityName;
    }

    // Ẩn bàn phím khi bấm tìm kiếm
    FocusScope.of(context).unfocus();

    setState(() {
      _futureWeather = null;
    });

    try {
      final cities = await _apiService.searchCities(query);
      if (cities.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('City not found. Try another name!')),
          );
        }
        return;
      }

      final city = cities.first;
      setState(() {
        _selectedCity = city;
        _futureWeather = _apiService.getCurrentWeather(city.latitude, city.longitude);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String getWeatherRecommendation(int code, double temp) {
    if (code >= 51 && code <= 65) return "It's raining, remember to bring an umbrella!";
    if (code >= 71 && code <= 75) return "It's snowing, dress warmly!";
    if (code == 95) return "Thunderstorm expected, stay indoors!";
    if (temp > 35) return "Very hot outside, stay hydrated!";
    if (temp < 15) return "It's chilly, wear a jacket.";
    if (code <= 3) return "Perfect weather for a walk!";
    return "Normal weather conditions.";
  }

  IconData getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code >= 1 && code <= 3) return Icons.cloud;
    if (code >= 51 && code <= 65) return Icons.water_drop;
    if (code >= 71 && code <= 75) return Icons.ac_unit;
    if (code == 95) return Icons.flash_on;
    return Icons.wb_cloudy;
  }

  String getWeatherDescription(int code) {
    if (code == 0) return "Clear Sky";
    if (code >= 1 && code <= 3) return "Partly Cloudy";
    if (code >= 51 && code <= 65) return "Rain Showers";
    if (code >= 71 && code <= 75) return "Snow Showers";
    if (code == 95) return "Thunderstorm";
    return "Overcast / Fog";
  }

  Color getWeatherColor(int code) {
    if (code == 0) return const Color(0xFFF59E0B); // Sun yellow
    if (code >= 1 && code <= 3) return const Color(0xFF64748B); // Cloudy gray
    if (code >= 51 && code <= 65) return const Color(0xFF3B82F6); // Rain blue
    if (code >= 71 && code <= 75) return const Color(0xFF0EA5E9); // Snow light blue
    if (code == 95) return const Color(0xFF8B5CF6); // Thunder purple
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // Very light sky blue
      appBar: AppBar(
        title: const Text('Weather Companion', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: 0.5)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.location_city, color: Color(0xFF0EA5E9)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF0EA5E9)),
                      onPressed: () => _searchAndFetchWeather(),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onSubmitted: (_) => _searchAndFetchWeather(),
                ),
              ),
            ),
            
            // Suggested Cities List
            SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _suggestedCities.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ActionChip(
                    label: Text(_suggestedCities[index]),
                    labelStyle: const TextStyle(color: Color(0xFF0369A1), fontWeight: FontWeight.w500),
                    backgroundColor: const Color(0xFFE0F2FE),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () => _searchAndFetchWeather(_suggestedCities[index]),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Weather Content
            Expanded(
              child: _selectedCity == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wb_cloudy_outlined, size: 80, color: Colors.blue.shade200),
                          const SizedBox(height: 16),
                          const Text('Search or select a city to see the weather', style: TextStyle(color: Color(0xFF64748B), fontSize: 16)),
                        ],
                      ),
                    )
                  : FutureBuilder<Weather>(
                      future: _futureWeather,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFF0EA5E9)));
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Failed to load weather: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                          );
                        } else if (snapshot.hasData) {
                          final weather = snapshot.data!;
                          final iconColor = getWeatherColor(weather.weatherCode);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              children: [
                                // Main Weather Card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        _selectedCity!.name,
                                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedCity!.country,
                                        style: const TextStyle(fontSize: 16, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 24),
                                      Icon(
                                        getWeatherIcon(weather.weatherCode),
                                        size: 100,
                                        color: iconColor,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '${weather.temperature}°C',
                                        style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                                      ),
                                      Text(
                                        getWeatherDescription(weather.weatherCode),
                                        style: TextStyle(fontSize: 20, color: iconColor, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Details Row
                                Row(
                                  children: [
                                    Expanded(child: _buildDetailCard(Icons.thermostat, 'Feels Like', '${weather.feelsLike}°C', Colors.orange)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildDetailCard(Icons.water_drop, 'Humidity', '${weather.humidity}%', Colors.blue)),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildDetailCard(Icons.air, 'Wind', '${weather.windSpeed} km/h', Colors.teal)),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Recommendation Card
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF0EA5E9), Color(0xFF3B82F6)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(color: const Color(0xFF0EA5E9).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                                        child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 28),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Daily Tip', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 4),
                                            Text(
                                              getWeatherRecommendation(weather.weatherCode, weather.temperature),
                                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 80), // Padding for bottom nav
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}
