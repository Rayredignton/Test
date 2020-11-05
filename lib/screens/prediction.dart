import 'package:flutter/material.dart';
import 'package:weather_app/screens/weatherWidget.dart';
import 'package:weather_app/services/forcast.dart';


class PredictionPage extends StatelessWidget {

  final Weather prediction;

  PredictionPage({this.prediction});

  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      appBar:  AppBar(
        title:  Text("Prediction"),
      ),
      body:  Padding(
        padding:  EdgeInsets.all(16.0),
        child: WeatherPage(weather: prediction)
      )
    );
  }
  
}