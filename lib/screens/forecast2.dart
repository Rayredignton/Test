import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:weather_app/services/forcast.dart';
import 'package:weather_app/services/forecastService.dart';

class OpenWeatherCurrentService implements WeatherService{

  final String _endpoint;
  final Client _client;
  final String _appId;

  OpenWeatherCurrentService(this._client, this._endpoint, this._appId);
  
  Future<Weather> get(double lat, double lon) async {
    final url = _endpoint + "weather?lat=$lat&lon=$lon&appId=$_appId&units=metric";    
    final response = await _client.get(url);
    if (response != null && response.statusCode == 200) {
      return WeatherMapper.map(json.decode(response.body));
    } else {
      throw Exception("Request error");
    }
  }

}

class WeatherMapper {
  
  static Weather map(Map<String, dynamic> json) {
    Map<String, dynamic> weather =  json['weather'][0];
    Map<String, dynamic> main = json['main'];
    Map<String, dynamic> wind = json['wind'];
    final timestamp = json['dt'];
    DateTime dateTime =  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return Weather(
      name: json['name'] != null ? json['name'] : "",
      description: weather['description'],
      icon: weather['icon'],
      temperature: main['temp'] * 1.0,
      minTemperature: main['temp_min'] * 1.0,
      maxTemperature: main['temp_max'] * 1.0,
      pressure: main['pressure'] * 1.0,
      humidity: main['humidity'] * 1.0,
      windSpeed: wind['speed'] * 1.0,
      dateTime: dateTime
    );
  }

}