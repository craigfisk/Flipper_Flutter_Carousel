// card_data.dart
import 'package:flutter/cupertino.dart';

final List<CardViewModel> demoCards = [
  new CardViewModel (
    backdropAssetPath: '/assets/van_on_beach.jpg', 
    address: '10TH STREET',
    minHeightInFeet: 2,
    maxHeightInFeet: 3,
    tempInDegrees: 65.1,
    weatherType: 'Mostly Cloudy',
    windSpeedInMph: 11.2,
    cardinalDirection: 'ENE',
  ),
  new CardViewModel (
    backdropAssetPath: '/assets/dusk_waves.jpg', 
    address: '10TH STREET NORTH\N TO 14TH STREET NORTH',
    minHeightInFeet: 6,
    maxHeightInFeet: 7,
    tempInDegrees: 54.5,
    weatherType: 'Rain',
    windSpeedInMph: 20.5,
    cardinalDirection: 'E',
  ),
  new CardViewModel (
    backdropAssetPath: '/assets/board_walk.jpg', 
    address: 'BELLS BEACH',
    minHeightInFeet: 3,
    maxHeightInFeet: 4,
    tempInDegrees: 61.0,
    weatherType: 'Sunny',
    windSpeedInMph: 19.9,
    cardinalDirection: 'W',
  ),

]