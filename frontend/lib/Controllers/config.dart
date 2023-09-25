import 'package:flutter/material.dart';

Color primaryColor = Color(0xff532754);
Color primaryColor2 = Color(0xff0d6b6a);

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey,blurRadius: 5,offset: Offset(0,2))
];


List<Map> navList = [
  {'icon': Icons.pets_rounded,'title': 'Adoption'},
  {'icon': Icons.markunread_mailbox_rounded,'title': 'Donation'},
  {'icon': Icons.add_rounded,'title': 'Add Pet'},
  {'icon': Icons.favorite_rounded,'title': 'Favorites'},
  {'icon': Icons.mail_rounded,'title': 'Messages'},
  {'icon': Icons.person,'title': 'Profile'},
];