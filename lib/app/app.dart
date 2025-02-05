import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/app/ui/themes/app_theme.dart';
import 'package:weather_app/app/ui/screens/home_screen.dart';
import 'package:weather_app/app/domain/state/weather_state.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => WeatherState())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: HomeScreen(),
      ),
    );
  }
}
