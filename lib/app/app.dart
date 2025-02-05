import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/domain/cubit/weather_cubit.dart';
import 'package:weather_app/app/ui/themes/app_theme.dart';
import 'package:weather_app/app/ui/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => WeatherCubit())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: HomeScreen(),
      ),
    );
  }
}
