import 'package:flutter/material.dart';
import 'package:take_home_quiz1/screens/home.dart';

void main(){
  runApp( HomeQuizApp());
}

class HomeQuizApp extends StatelessWidget {
  const HomeQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    
    );
  }
}