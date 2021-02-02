import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class weatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  var place;

  Future getWeather (String S) async{
    http.Response response = await http.get('https://api.openweathermap.org/data/2.5/weather?q=$S&units=imperial&appid=ceeacef963d0b5e8492c9bc387516f43');
    var results = jsonDecode(response.body);

    setState(() {
      this.temp = results['main']['temp'];
      temp = (temp-32)*(5/9);
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }


  void onTextFieldSubmitted(String input) {
    getWeather(input);
    place=input;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(0, 23, 61, .9),
              child: Column(
                children: <Widget>[
                  TextField(
                    onSubmitted: (String input) {
                      onTextFieldSubmitted(input);
                    },
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Search a location...',
                      hintStyle:
                      TextStyle(color: Colors.white, fontSize: 20.0),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),

            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Color.fromRGBO(0, 23, 61, .9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    temp!=null? 'In $place '+temp.floor().toString()+'\u00B0 C': '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14.0),
                    child: Text(
                      currently !=null? currently.toString(): '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text('Temperature'),
                    trailing: Text(temp!=null? temp.floor().toString()+'\u00B0 C': ''),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text('Weather'),
                    trailing: Text(description!=null? description.toString():''),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.solidSun),
                    title: Text('Humidity'),
                    trailing: Text(humidity!=null ? humidity.toString():''),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text('Wind Speed'),
                    trailing: Text(windSpeed != null? windSpeed.toString(): ''),
                  ),
                ],
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
