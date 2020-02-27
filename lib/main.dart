import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'card_data.dart';

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
//            child: Padding(
//              padding: const EdgeInsets.all(16.0),
              child: new CardFlipper(
                cards: demoCards,
              ),
            ),
//          ),
          
          // bottom bar
          // new Container(
          //   width: double.infinity,
          //   height: 50.0,
          //   color: Colors.grey,
          //   ) 
          new BottomBar (
            cardCount: demoCards.length,
            scrollPercent: 0.0,
          ),

          ],
        ),
      );
  }
}


class CardFlipper extends StatefulWidget{
  final List<CardViewModel> cards;
  
    CardFlipper({
      this.cards
    });
  
    @override 
    _CardFlipperState createState() => new _CardFlipperState();
  
}


class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin {
  // items to always be tracing:
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override 
  void initState() {
    super.initState();

    finishScrollController = new AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )
    ..addListener(() {
      setState(() {
        // using built-in linear interpretation function lerpDouble()
        scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);  
      });
     });
  }

  @override 
  void dispose() {
    finishScrollController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    print('...starting horizontal drag...');
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    print('...starting horizontal drag update drag...');
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    //final numCards = 3;
    setState(() {
      scrollPercent = (startDragPercentScroll + (-singleCardDragPercent / widget.cards.length)).clamp(0.0, 1.0 - (1/ widget.cards.length));
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    //final numCards = 3;

    print('...starting horizontal drag end...');
    // start the animation from wherever the user ended their scrolling
    finishScrollStart = scrollPercent;
    // figure out where to animate to...
    // round up if over half; round down if under half
    finishScrollEnd = (scrollPercent * widget.cards.length).round() / widget.cards.length;   
    finishScrollController.forward(from: 0.0);


    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    final cardCount = widget.cards.length;

    int index = -1;
    return widget.cards.map((CardViewModel viewModel) {
      print('Current index is ' + index.toString());
      ++index;
      print('Parameters: viewModel: '+viewModel.toString()+' index: '+index.toString()+' cardCount: '+cardCount.toString()+' scrollPercent: '+scrollPercent.toString() );
      return _buildCard(viewModel, index, cardCount, scrollPercent);
    }).toList();
  }

  // get the card index and count of cards
  Widget _buildCard(CardViewModel viewModel, int cardIndex, int cardCount, double scrollPercent) {
    // calculate the cardscrollpercent
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / cardCount);

    return FractionalTranslation(
      // offset by 10% on the x-axis * cardIndex
      translation: new Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Card(
          viewModel: viewModel,
          parallaxPercent: parallax,
        ),
      ),
    );
  } 

  @override 
  Widget build(BuildContext context) {
    // surround the stack with a gesture detector
    return GestureDetector( 
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: new Stack(
        // will return a list of cards in a stack
        children: _buildCards(),
      )
    );
  }
}

// One hard-coded card to work out the layout.
class Card extends StatelessWidget {
  final CardViewModel viewModel;
  final double parallaxPercent;

  Card({
    this.viewModel,
    this.parallaxPercent = 0.0,
  });


  @override 
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // background
        new ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: FractionalTranslation(
            translation: new Offset(parallaxPercent * 2.0, 0.0),
            child: OverflowBox(
              maxWidth: double.infinity,
              child: new Image.asset(
                //'assets/van_on_beach.jpg',
                viewModel.backdropAssetPath,
                fit: BoxFit.cover,
              ),
            ),   
          ),     
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: new Text( 
                //'10th Street'.toUpperCase(),
                viewModel.address.toUpperCase(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  //'2 - 3',
                  '${viewModel.minHeightInFeet} - ${viewModel.maxHeightInFeet}', 
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 140.0,
                    fontFamily: 'petita',
                    letterSpacing: -5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                    child: new Text( 
                      'FT',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontFamily: 'petita',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: new Text(
                    //'65.1',
                    '${viewModel.tempInDegrees}',
                    style: new TextStyle(
                      color: Colors.white,
                      fontFamily: 'petita',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            new Expanded(child: new Container()),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: new Container(              
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(30.0),
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        //'Mostly cloudy',
                        '${viewModel.weatherType}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Icon(
                            Icons.wb_cloudy,
                            color: Colors.white,
                        ),
                      ),
                      new Text(
                        //'11.3mph ENE',
                        '${viewModel.windSpeedInMph}mph ${viewModel.cardinalDirection}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          ),
                        ),
                      ],
                    
                    ),
                  ),
              ),
            ),
            ],
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {

  final int cardCount;
  final double scrollPercent;

  BottomBar({
    this.cardCount,
    this.scrollPercent,
  });

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: new Row(
        children: <Widget> [
          new Expanded(
            child: new Center(
              child: new Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              width: double.infinity,
              height: 5.0,
              child: new ScrollIndicator(
                  cardCount: cardCount,
                  scrollPercent: scrollPercent,
                ),
            ),
          ),
          new Expanded(
            child: new Center(
              child: new Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {

  final int cardCount;
  final double scrollPercent;

  ScrollIndicator({
    this.cardCount,
    this.scrollPercent,
  });

  @override 
  Widget build(BuildContext context) {
//    return new Container();
      return new CustomPaint(
        painter: new ScrollIndicatorPainter(
          cardCount: cardCount,
          scrollPercent: scrollPercent,
        ),
        child: new Container()
        );
  }
}

class ScrollIndicatorPainter extends CustomPainter {

  final int cardCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({
    this.cardCount,
    this.scrollPercent,
  }) : trackPaint = new Paint()
        ..color = const Color(0xFF444444)
        ..style = PaintingStyle.fill,
        thumbPaint = new Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

  @override 

  void paint(Canvas canvas, Size size) {
    // draw track
    canvas.drawRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
      trackPaint);

    // thumb
    final thumbWidth = size.width / cardCount;
    // thumbLeft = the position
    final thumbLeft = scrollPercent * size.width;

    // draw track
    canvas.drawRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          thumbLeft,
          0.0,
          thumbWidth,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
      thumbPaint);

  }

  @override 
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}