import 'package:flutter/material.dart';
import 'package:frontend/utils/spacing_widgets.dart';

import 'components/app_bar.dart';
import 'components/menu_items.dart';
import 'components/setting_logout_menu.dart';


class ShopDrawerScreen extends StatefulWidget {
  const ShopDrawerScreen({super.key});

  @override
  State<ShopDrawerScreen> createState() => _ShopDrawerScreenState();
}

class _ShopDrawerScreenState extends State<ShopDrawerScreen> {
  @override
  void initState(){print('object');}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcf4055),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            addVerticalSpace(60.0),
            const ShopDrawerAppBar(),
            const Spacer(),
            const ShopMenuItems(),
            const Spacer(),
            const ShopSettingLogOutMenus(),
            addVerticalSpace(50.0),
          ],
        ),
      ),
    );
  }
}
