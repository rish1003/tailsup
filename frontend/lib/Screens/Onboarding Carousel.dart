import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Sign%20Up.dart';
import 'package:frontend/Screens/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Reusables/onboardingscreens.dart';

class onboardingCarousel extends StatefulWidget {
  final SharedPreferences prefs;
  onboardingCarousel({required this.prefs});
  @override
  _onboardingCarouse createState() => _onboardingCarouse();
}

class _onboardingCarouse extends State<onboardingCarousel> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imagePaths = [
    'assets/onboarding1.png',
    'assets/onboarding2.png',
    'assets/onboarding3.png',
    'assets/onboarding4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingScreen(imagePath: imagePaths[index]);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left:80.0,right:80.0,bottom:130.0),
              child: ElevatedButton(
                onPressed: () async {
                  await widget.prefs.setBool('isFirstTime', false);

                  // Navigate to the main app screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD69FD7), // Background color
                  foregroundColor: Color(0xFFFFFFFF),
                  surfaceTintColor:Color(0xFFD69FD7)
                  // Text color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.login,color: Color(0xFFFFFFFF),),
                    Text('  Sign In',style:TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left:80.0,right:80.0,bottom:80.0),
              child: ElevatedButton(
                onPressed: () async {
                  await widget.prefs.setBool('isFirstTime', false);

                  // Navigate to the main app screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD69FD7), // Background color
                    foregroundColor: Color(0xFFFFFFFF),
                    surfaceTintColor:Color(0xFFD69FD7)// Text color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.supervisor_account_outlined,color: Color(0xFFFFFFFF)),
                    Text('  Sign Up',style:TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < imagePaths.length; i++) {
      indicators.add(_indicator(i == _currentPage));
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF2A3D61) : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
