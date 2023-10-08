import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/utils/spacing_widgets.dart';

import '../../../Controllers/config.dart';
import 'cart.dart';

Row buildAppBar({
  required context,
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
                color: Color(0xffcf4055),
                size: 25.0,
              ),
            )
          : IconButton(
              onPressed: () => openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: Color(0xffcf4055),
                size: 25.0,
              ),
            ),
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.shopping_cart,
                color: Color(0xffcf4055),
              ),
              addHorizontalSpace(7.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffcf4055),
                ),
              ),
              addHorizontalSpace(80.0),
               InkWell(
                 onTap: (){
                   showDialog(
                     context: context,
                     builder: (context) {
                       return ShoppingCartDialog();
                     },
                   );
                 },
                child: Container(
                  width: 35,
                  height: 35,

                  decoration: BoxDecoration(
                      color: Color(0x90cf4055),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    ],
  );
}
