import 'weather_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/domain/services/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial()) {
    initialize();
  }

  Future<void> initialize() async {
    final box = Hive.box('settings');

    String? cityName = box.get('city_name');

    cityName ??= await getCityName();

    if (cityName != null) getWeather(cityName);
  }

  Future<Position?> getLocation() async {
    LocationPermission status = await Geolocator.checkPermission();

    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();

      if (status == LocationPermission.denied) return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String?> getCityName() async {
    final location = await getLocation();

    if (location == null) return null;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);

    return placemarks.isNotEmpty ? placemarks[0].locality : null;
  }

  Future<void> getWeather(String cityName) async {
    emit(WeatherLoading());

    try {
      final box = Hive.box('settings');

      final weather = await WeatherService().getWeather(cityName);

      await box.put('city_name', cityName);

      emit(WeatherLoaded(weather));
    }
    // error...

    catch (e) {
      emit(WeatherError('Ошибка загрузки погоды: $e'));
    }
  }

  void onSend(String cityName) {
    if (cityName.trim().isEmpty) return;

    getWeather(cityName);
  }
}
