
import 'package:flutter/material.dart';

class ClickableContainer extends StatelessWidget {
  final String backgroundImage;
  final String text;
  final VoidCallback onPressed;
  final Color shadowColor;
  final double a_height;
  final double a_width;

  ClickableContainer({
    required this.backgroundImage,
    required this.text,
    required this.onPressed,
    required this.shadowColor,
    required this.a_height,
    required this.a_width,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: a_height,
        width: a_width,

          decoration: BoxDecoration(
              color: shadowColor,
              borderRadius: BorderRadius.circular(20)
          ),

        child: Row(
          
          children: [

            Container(width: a_width*0.60,child: Image.asset(backgroundImage)),
           Container(
             padding: EdgeInsets.all(20),
             child: Text(
                text, textAlign: TextAlign.end,
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,

                ),

              ),
           ),
          ],
        )

        ),


    );
  }
}

class ClickableContainer2 extends StatelessWidget {
  final String backgroundImage;
  final String text;
  final VoidCallback onPressed;
  final Color shadowColor;
  final double a_height;
  final double a_width;

  ClickableContainer2({
    required this.backgroundImage,
    required this.text,
    required this.onPressed,
    required this.shadowColor,
    required this.a_height,
    required this.a_width,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          height: a_height,
          width: a_width,

          decoration: BoxDecoration(
              color: shadowColor,
              borderRadius: BorderRadius.circular(20)
          ),

          child: Row(

            children: [


              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  text, textAlign: TextAlign.end,
                  style:  TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,

                  ),

                ),
              ),
              Container(width: a_width*0.60,child: Image.asset(backgroundImage)),
            ],
          )

      ),


    );
  }
}