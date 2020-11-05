import 'package:http/http.dart' show Client;
import 'package:location/location.dart';
import 'package:weather_app/services/forcast.dart';
import 'dart:convert';


class OpenWeatherForecastService implements ForecastService {
final _apiKey = '&units=metric&appid=67131b30b23b0c70fe55b9db88a61649';
  final _apiURL = 'https://api.openweathermap.org/data/2.5/';
  final String _endpoint;
  final Client _client;
  final String _appId;

  OpenWeatherForecastService(this._client, this._endpoint, this._appId);

  Future<Forecasts> get(double lat, double lon) async {
    final url ="https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appId=67131b30b23b0c70fe55b9db88a61649&units=metric";    
    final response = await _client.get(url);
    if (response != null && response.statusCode == 200) {
      return _mapForecast(json.decode(response.body));
    } else {
      throw Exception("Request error");
    }
  }

  Forecasts _mapForecast(Map<String, dynamic> json) {
    final String name =  json['city']['name'];
    final List<dynamic> cities = json['list'] as List;    
    final List<Weather> predictions = cities.map((i) => WeatherMapper.map(i)).toList();
    return Forecasts(name: name, predictions: predictions);
  }

}
class WeatherMapper {
  
  static Weather map(Map<String, dynamic> json) {
    Map<String, dynamic> weather =  json['weather'][0];
    Map<String, dynamic> main = json['main'];
    Map<String, dynamic> wind = json['wind'];
    final timestamp = json['dt'];
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
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

abstract class WeatherService {
  Future<Weather> get(double lat, double lon);
}

abstract class ForecastService {
  Future<Forecasts> get(double lat, double lon);
}

class WeatherUseCase {

  Location _location;
  WeatherService _weatherService;
  ForecastService _forecastService;

  WeatherUseCase(this._location, this._weatherService, this._forecastService);

  Future<WeatherResult> get() async {    
    LocationData data = await _location.getLocation();    
    Weather weather = await _weatherService.get(data.latitude, data.longitude);
    Forecasts forecast = await _forecastService.get(data.latitude, data.longitude);
    return Future.value(WeatherResult(weather: weather, forecast: forecast));
  }

}
class WeatherResult {

  Weather weather;
  Forecasts forecast;

  WeatherResult({this.weather, this.forecast});

}