import 'dart:math';
import 'package:flutter/material.dart';

List<Color> backgroundColors = [
  Color.fromRGBO(204, 229, 255, 1), // Light Blue
  Color.fromRGBO(215, 249, 233, 1), // Pale Green
  Color.fromRGBO(255, 248, 225, 1), // Pale Yellow
  Color.fromRGBO(245, 230, 204, 1), // Beige
  Color.fromRGBO(255, 214, 214, 1), // Light Pink
  Color.fromRGBO(229, 229, 229, 1), // Light Grey
  Color.fromRGBO(255, 240, 240, 1), // Pale Pink
  Color.fromRGBO(230, 249, 255, 1), // Pale Blue
  Color.fromRGBO(212, 237, 218, 1), // Mint Green
  Color.fromRGBO(255, 243, 205, 1), // Pale Orange
];

Color getRandomColor() {
  final random = Random();
  return backgroundColors[random.nextInt(backgroundColors.length)];
}
