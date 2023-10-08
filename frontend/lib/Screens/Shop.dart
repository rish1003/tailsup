import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Screens/shop/main_Shop.dart';
import 'package:frontend/Screens/shop_drawer/drawer.dart';
import 'package:frontend/Screens/shop_home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShopApp extends StatefulWidget {

  const ShopApp({super.key});

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  @override
  void initState(){
    super.initState();
    setpage();
  }
  setpage() async{
    print('shopapp');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('shophome', true);
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Stack(
        children: const <Widget>[
          ShopDrawerScreen(),
          MyShopHomePage(),
        ],
      ),
    );
  }
}
