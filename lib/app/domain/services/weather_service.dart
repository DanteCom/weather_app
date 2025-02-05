import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/app/domain/models/weather.dart';

class WeatherService {
  // Variables

  final String apiKey = '14fa83aec7e886848dce6a4a521c3e3e';

  // Functions

  Future<Weather?> getWeather(String cityName) async {
    final dio = Dio();

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final json = response.data;

        return Weather.fromJson(json);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }
  }
}
