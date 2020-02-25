import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Carousel',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      /*
      appBar: AppBar(
        title: Text('Ralph'),
      ),
      */
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // room for status bar
          new Container (
            width: double.infinity,
            height: 20.0,
          ),
          // cards
          new Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Card(
              ),
            ),
          ),
          // bottom bar
          new Container(
            width: double.infinity,
            height: 50.0,
            color: Colors.grey,
            ) 
          ],
        ),
      );
  }
}

class Card extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // background
        new ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: new Image.asset(
            //'assets/board_walk.jpg',
            //'assets/dusk_waves.jpg',
            'assets/van_on_beach.jpg',
            fit: BoxFit.cover,
          ),
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: new Text( 
                '10th Street'.toUpperCase(),
                style: new TextStyle(
                  color: Colors.white, 
                  fontSize: 20.0, 
                  fontFamily: 'petita', 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 2.0,
                ),
              ),
            ),
            new Expanded(child: new Container()),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '2 - 3', 
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 140.0,
                    fontFamily: 'petita',
                    letterSpacing: -5.0,
                  ),
                ),
              ],
            ),
            new Expanded(child: new Container()),
          ],
        ),
      ],
    );
  }
}