import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;

void main() => runApp(App());

class App extends StatefulWidget{
  @override
  AppState createState() => AppState();
}

class AppState extends State<App>
{

  TextEditingController _cityFieldController = new TextEditingController();
  final apiID ="5546569946b68dfac911278448b6130f";
  final defaultCity = "Jamshedpur";

  String _cityEntered;

  void showStuff() async {
    Map data = await getWeather(apiID,defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Klimatic - Know your Weather',
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        backgroundColor: Color.fromARGB(100, 19, 21, 12),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(100, 51, 153, 137),
          centerTitle: true,
          title: Text('KLIMATIC'),
          actions: <Widget>[
            GestureDetector(
              child: Container(child:Icon(Icons.search),margin:EdgeInsets.fromLTRB(1.0, 0.0, 13.0, 0.0),),
              onLongPress: (){
                _cityFieldController = new TextEditingController(text:'Kolkata');
              },
              onTap: (){
                setState(() {
                  _cityEntered = _cityFieldController.text;
                });
                build(context);
              },
            )
          ],
        ),

        body: Container(
            child: ListView(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
              child: new TextFormField(

                decoration: new InputDecoration(

                  filled: true,
                  hintStyle: TextStyle(color: Color.fromARGB(100, 255, 250, 251)),
                  fillColor: Color.fromARGB(100, 51, 153, 137),
                  hintText: 'Enter the city:',
                ),
                autofocus: false,
                controller: _cityFieldController,
                style: TextStyle(fontFamily: "Quantico"),

              ),
            ),
            displayData(),

            new Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(0.0, 40.9, 20.9, 0.0),
              child: new Text('${_cityEntered == null ? defaultCity : _cityEntered}',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 54,color: Color.fromARGB(100, 125, 226, 209)),),
            ),
          ],
        )),
      ),
    );
  }

  Widget displayData()
  {
    return new FutureBuilder(future: getWeather(apiID, _cityEntered == null ? defaultCity : _cityEntered) ,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){

          if(snapshot.hasData){
            Map content = snapshot.data;
            return Container(
              padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 30),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(100, 51, 153, 137)),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text((content['main']['temp'].toString()+"°C"),style: TextStyle(fontWeight: FontWeight.w500, fontSize: 54, color: Color.fromARGB(100, 255, 250, 251)),),
                    padding: EdgeInsets.fromLTRB(5, 40, 5, 10),
                  ),
                  Container(
                    child: Text((content['main']['temp_max'].toString()+"/"+content['main']['temp_min'].toString()),style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24,color: Color.fromARGB(100, 255, 250, 251)),),
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  ),
                  Container(
                    child: Text("Feels like: "+content['main']['feels_like'].toString()+"°C",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24,color: Color.fromARGB(100, 255, 250, 251)),),
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  ),
                  Container(
                    child: Text(("Humidity: "+content['main']['humidity'].toString()+"%"),style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24,color: Color.fromARGB(100, 255, 250, 251)),),
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 40),
                  ),
                ],
              ),
            ));
          } else {
            return new Container();
          }
        });
  }
  Future<Map> getWeather(String apiId, String city) async {
    String apiURL = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId&units=metric';

    http.Response response = await http.get(apiURL);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

}

TextStyle cityStyle(){
  return new TextStyle( fontFamily: "Quantico",
    color: Colors.white,
    fontSize: 60,
  );
}
