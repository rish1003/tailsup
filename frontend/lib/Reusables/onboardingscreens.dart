import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  final String imagePath;

  OnboardingScreen( {required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
