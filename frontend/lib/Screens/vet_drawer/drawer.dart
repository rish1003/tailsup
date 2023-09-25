import 'package:flutter/material.dart';
import 'package:frontend/Controllers/config.dart';
import 'package:frontend/utils/spacing_widgets.dart';

import 'components/app_bar.dart';
import 'components/menu_items.dart';
import 'components/setting_logout_menu.dart';


class VetDrawerScreen extends StatefulWidget {
  const VetDrawerScreen({super.key});

  @override
  State<VetDrawerScreen> createState() => _VetDrawerScreenState();
}

class _VetDrawerScreenState extends State<VetDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor2,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            addVerticalSpace(60.0),
            const VetDrawerAppBar(),
            const Spacer(),
            const VetMenuItems(),
            const Spacer(),
            const SettingLogOutMenus(),
            addVerticalSpace(50.0),
          ],
        ),
      ),
    );
  }
}
