import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_settings/open_settings.dart';
import 'package:weather_app/screens/location_screen.dart';
import 'package:weather_app/services/location_info.dart';
import 'package:weather_app/services/weatherApi.dart';

import '../utilities/constants.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:  Text('Are you sure?'),
            content:  Text('Do you want to exit an App'),
            actions: <Widget>[
               FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child:  Text('No'),
              ),
               FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child:  Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void getUserLocationData() async {
    //Checking Internet Connection
    if (await kInternetConnectivityChecker() == true) {
      // getting user location
      if (!await LocationInfo().getUserLocationAndGPS()) {
        Navigator.pushReplacementNamed(context, '/CityScreen');
      } else {
        LocationInfo locationInfo =  LocationInfo();
        await locationInfo.getUserLocationData();
        //getting weather data on basis of location
        Weather weather =  Weather();
        dynamic weatherData = await weather.getLocationWeatherCurrentData(
            longitude: locationInfo.longitude, latitude: locationInfo.latitude);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LocationScreen(
                weatherData: weatherData,
              );
            },
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>  AlertDialog(
          title:  Text(' No Internet '),
          content:  Text(
              'This app requires Internet connection. Do you want to continue?'),
          actions: <Widget>[
             FlatButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child:  Text('cancel'),
            ),
             FlatButton(
              onPressed: () async {
                if (await kInternetConnectivityChecker() == false) {
                  OpenSettings.openWIFISetting();
                }
                Navigator.pop(context);
                getUserLocationData();
              },
              child:  Text('ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        child: Center(
          child: SpinKitRing(
            color: Colors.white,
            size: 70.0,
          ),
        ),
      ),
    );
  }
}
