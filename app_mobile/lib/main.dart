import 'package:flutter/material.dart';
import 'splash_screen.dart'; 

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(secondary: Colors.black, primary: Colors.red.shade900)
    ),
  ));
}