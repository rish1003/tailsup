import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Controllers/homescreencontrol.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/utils/spacing_widgets.dart';

class SettingLogOutMenus extends StatelessWidget {
  const SettingLogOutMenus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FaIcon(
          FontAwesomeIcons.house,
          color: Colors.grey[400],
        ),
        addHorizontalSpace(25.0),
        Container(
          width: 2.0,
          height: 25.0,
          color: Colors.grey[400],
        ),
        addHorizontalSpace(25.0),
        InkWell(
          onTap: ()  {

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) => false, // This line prevents going back
            );

          },
          child:  Text(
            'Home',
            style: GoogleFonts.montserrat(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[200],
            ),

          ),
        ),

        const Spacer(),
      ],
    );
  }
}
