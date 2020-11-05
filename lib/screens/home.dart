import 'package:http/http.dart' show Client;
import 'package:weather_app/screens/current.dart';
import 'package:weather_app/services/forecastService.dart';

import 'package:location/location.dart';


import 'forecast2.dart';

class WeatherBuilder {
  
  CurrentWeatherPage build() {
    Location location = Location();
    Client client = Client();

    OpenWeatherCurrentService weatherService = OpenWeatherCurrentService(client, Constants.endpoint, Constants.appId);
    OpenWeatherForecastService forecastService = OpenWeatherForecastService(client, Constants.endpoint, Constants.appId);
    WeatherUseCase useCase = WeatherUseCase(location, weatherService, forecastService);
    
    return CurrentWeatherPage(weatherUseCase: useCase);
  }

}
class Constants {
  static String appId = "d6e481919bcce169184f16536bb64bd8";
  static String endpoint = "http://api.openweathermap.org/data/2.5/";
}