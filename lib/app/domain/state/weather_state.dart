import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/app/domain/models/weather.dart';
import 'package:weather_app/app/domain/services/weather_service.dart';

class WeatherState extends ChangeNotifier {
  // Variables

  String? _cityName;

  Weather? _weather;

  bool _isLoad = true;

  final _box = Hive.box('settings');

  final _controller = TextEditingController();

  // Getters

  bool get isLoad => _isLoad;

  String? get cityName => _cityName;

  Weather? get weather => _weather;

  TextEditingController get controller => _controller;

  bool get isActive => _controller.text.trim().isNotEmpty;

  // Functions

  Future<Position?> getLocation() async {
    bool permission = false;
    // bool serviceEnabled = false;

    // serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // if (!serviceEnabled) return null;

    LocationPermission status = await Geolocator.checkPermission();

    permission = !(status == LocationPermission.denied);

    if (!permission) {
      status = await Geolocator.requestPermission();

      permission = !(status == LocationPermission.denied);
    }

    if (!permission) return null;

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getWeather(String cityName) async {
    _isLoad = false;
    notifyListeners();

    _weather = await WeatherService().getWeather(cityName);

    await _box.put('city_name', cityName);

    _isLoad = true;
    notifyListeners();
  }

  Future<String?> getCityName() async {
    final location = await getLocation();

    if (location == null) return null;

    final latitude = location.latitude;

    final longitude = location.longitude;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark placemark = placemarks[0];

    return placemark.country;
  }

  void onSend(BuildContext context) {
    if (controller.text.trim().isEmpty) return;

    getWeather(controller.text);

    _cityName = controller.text;

    notifyListeners();

    controller.clear();

    FocusScope.of(context).unfocus();
  }

  Future<void> initialize() async {
    _cityName = await _box.get('city_name', defaultValue: null);

    _cityName ??= await getCityName();

    if (cityName == null) return;

    getWeather(cityName!);
  }

  String? capitalize(String? text) {
    if (text == null || text.isEmpty) return null;

    return text[0].toUpperCase() + text.substring(1);
  }

  void setState() => notifyListeners();

  // Initialize Weather State

  WeatherState() {
    initialize();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
