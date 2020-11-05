

class Forecasts {

  final String name;
  final List<Weather> predictions;

  Forecasts({this.name, this.predictions});

}
class Weather {
    
    final String name;
    final String description;
    final String icon;
    final double temperature;
    final double minTemperature;
    final double maxTemperature;
    final double pressure;
    final double humidity;
    final double windSpeed;
    final DateTime dateTime;

    Weather({this.name, this.description, this.icon, this.temperature, this.minTemperature, this.maxTemperature, this.pressure, this.humidity, this.windSpeed, this.dateTime});

}