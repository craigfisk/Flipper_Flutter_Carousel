import 'package:flutter/material.dart';
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
              child: new Container(),
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
