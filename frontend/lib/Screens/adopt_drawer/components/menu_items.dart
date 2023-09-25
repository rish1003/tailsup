import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Screens/adopt_home/components/favourites.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/utils/spacing_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            children: <Widget>[
              const FaIcon(
                FontAwesomeIcons.paw,
                color: Colors.white,
              ),
              addHorizontalSpace(15.0),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('adopthome', true);
                },
                child:  Text(
                  'Adoption',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                  ),

                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.solidHeart,
                color: Colors.grey[400],
              ),
              addHorizontalSpace(15.0),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('adopthome', false);
                },
                child:  Text(
                  'Favourites',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                  ),

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
