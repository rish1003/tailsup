import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/utils/spacing_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VetDrawerAppBar extends StatefulWidget {
  const VetDrawerAppBar({super.key});

  @override
  State<VetDrawerAppBar> createState() => _VetDrawerAppBarState();
}

class _VetDrawerAppBarState extends State<VetDrawerAppBar> {
  String phone ='';
  String name = '';
  void initState() {
    super.initState();
    getValue();
  }

  void getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('Phone')!;
      name = prefs.getString('Name')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: GoogleFonts.montserrat(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            addVerticalSpace(5.0),
            Text(
              phone,
              style: GoogleFonts.montserrat(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey[200],
              ),
            ),
          ],
        )
      ],
    );
  }
}
