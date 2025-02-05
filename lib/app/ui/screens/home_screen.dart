import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/app/domain/state/weather_state.dart';
import 'package:weather_app/app/ui/themes/themes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WeatherState>();
    final cityName = state.capitalize(state.cityName);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: FontStyles.s28w500,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (cityName != null)
              state.isLoad
                  ? Text(
                      state.weather?.temperature != null
                          ? "${state.weather?.temperature}°"
                          : "I couldn't find out what the temperature in $cityName was.",
                      textAlign: TextAlign.center,
                      style: FontStyles.s28w500,
                    )
                  : CircularProgressIndicator(),
            SizedBox(height: 10),
            if (state.weather?.temperature != null)
              Text(
                state.isActive ? state.controller.text : 'In $cityName',
                style: FontStyles.s28w500,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(left: 25, right: 10),
              child: TextField(
                controller: state.controller,
                decoration: InputDecoration(
                  border: AppTheme.outlineBorder,
                  focusedBorder: AppTheme.outlineBorder,
                  enabledBorder: AppTheme.outlineBorder,
                  disabledBorder: AppTheme.outlineBorder,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () => state.onSend(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.black),
            ),
            child: Icon(Icons.near_me_sharp),
          ),
        ],
      ),
    );
  }
}
