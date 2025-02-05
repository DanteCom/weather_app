import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/app/app.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');

  runApp(App());
}
