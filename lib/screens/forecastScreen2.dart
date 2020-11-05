import 'package:flutter/material.dart';
import 'package:weather_app/screens/forecast.dart';
import 'package:weather_app/screens/prediction.dart';
import 'package:weather_app/services/forcast.dart';
import 'package:weather_app/utilities/date.dart';


class ForecastPage extends StatelessWidget {
  
  final Forecasts forecast;

  ForecastPage({this.forecast});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = forecast.predictions.map((prediction) => _prediction(context, prediction)).toList();
    return Container(
  
          height:MediaQuery.of(context).size.height*0.7,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
             scrollDirection: Axis.vertical,
             children: items,
           ),
      );
  }

    Widget _prediction(BuildContext context, Weather prediction) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PredictionPage(prediction: prediction)));
      },
      child: Align(
        alignment: Alignment.topLeft,
              child: Container(
                height:MediaQuery.of(context).size.height*0.1,
                width:MediaQuery.of(context).size.width*0.9, child: Column(children: <Widget>[
          Row(
            children: [
              Text(prediction.temperature.toString() + "°C", style: TextStyle(fontSize: 27, color: Colors.black87)),
            SizedBox( width:MediaQuery.of(context).size.width*0.05,),
            Image.asset('assets/${prediction.icon}.png', scale: 1),
         SizedBox( width:MediaQuery.of(context).size.width*0.05,),
          Text(DateFormatter.dateTime(prediction.dateTime), style: TextStyle(fontSize:27 , color: Colors.black87))
         
          
            ],
          ),
         ]
        )
    ),
      )
    );
  }

}

