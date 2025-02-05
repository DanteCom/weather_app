import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/ui/themes/themes.dart';
import 'package:weather_app/app/domain/cubit/weather_state.dart';
import 'package:weather_app/app/domain/cubit/weather_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherCubit = context.read<WeatherCubit>();
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: FontStyles.s28w500,
        ),
      ),
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return CircularProgressIndicator();
            } else if (state is WeatherLoaded) {
              return state.weather != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${state.weather?.temperature}°",
                          textAlign: TextAlign.center,
                          style: FontStyles.s28w500,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "In ${state.weather?.cityName}",
                          style: FontStyles.s28w500,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Text(
                      "I couldn't find such a city.",
                      style: FontStyles.s28w500,
                      textAlign: TextAlign.center,
                    );
            } else if (state is WeatherError) {
              return Text(
                state.message,
                style: TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              );
            } else {
              return Text(
                "Введите город для получения погоды",
                style: FontStyles.s28w500,
                textAlign: TextAlign.center,
              );
            }
          },
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
                controller: controller,
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
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              await weatherCubit.getWeather(controller.text.trim());

              if (!context.mounted) return;

              controller.clear();

              FocusScope.of(context).unfocus();
            },
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
