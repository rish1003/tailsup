import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/utils/spacing_widgets.dart';

import '../../../Controllers/config.dart';

Row buildAppBar({
  required bool isDrawerOpen,
  required void Function() openDrawer,
  required void Function() closeDrawer,
  required String text
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      isDrawerOpen
          ? IconButton(
              onPressed: () => closeDrawer(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xff0d6b6a),
                size: 25.0,
              ),
            )
          : IconButton(
              onPressed: () => openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: Color(0xff0d6b6a),
                size: 25.0,
              ),
            ),
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.medical_services,
                color: Color(0xff0d6b6a),
              ),
              addHorizontalSpace(5.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0d6b6a),
                ),
              ),
              addHorizontalSpace(115.0),
            ],
          ),
        ],
      ),
    ],
  );
}
