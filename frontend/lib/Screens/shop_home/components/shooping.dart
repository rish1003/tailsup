import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/shop_home/components/prod_page.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Controllers/config.dart';
import '../../../Controllers/pet_model.dart';
import 'package:frontend/global.dart';

import '../../../Controllers/vet_model.dart';
import '../../adopt_details/details.dart';

import '../../shop/utils.dart';
import '../../vet_details/details.dart';

class MyShoppingPage extends StatefulWidget {
  const MyShoppingPage({Key? key});

  @override
  State<MyShoppingPage> createState() => _MyShoppingPageState();
}

class _MyShoppingPageState extends State<MyShoppingPage> {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(global.url+'/categories/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Category> categories = [];

      for (var item in data) {
        categories.add(Category.fromJson(item));
      }

      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Stack(
              children: [
                SizedBox(height: 30),
                Container(

                  padding: EdgeInsets.all(5),
                  // height: 200,
                  width: double.infinity,
                  child: Row(
                      children: [
                        Image.asset('assets/shop.png',height:120),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Best',textAlign: TextAlign.left,
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffcf4055),
                              ),),
                            Text('Pet',textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffcf4055),
                              ),),
                            Text('Products',textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffcf4055),
                              ),)
                          ],
                        ),
                      ]
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0x90cf4055),width: 8),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
                // Positioned(
                //     child: Image(
                //   image: AssetImage('assets/images/basket.png'),
                // ))
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Categories",
                  style: GoogleFonts.montserrat(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff413c3c),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Category>>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final categories = snapshot.data;

                  // Split the categories into chunks of 2 categories per row
                  final chunkedCategories = <List<Category>>[];
                  for (int i = 0; i < categories!.length; i += 2) {
                    final endIndex = i + 2;
                    chunkedCategories.add(categories.sublist(i, endIndex < categories.length ? endIndex : categories.length));
                  }

                  return Column(
                    children: [

                      for (var rowCategories in chunkedCategories)

                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (var category in rowCategories)
                              Container(
                                padding: EdgeInsets.only(bottom:30),
                                child: CategoryTile(
                                  context: context,
                                  category: category,
                                  // Replace with your image asset
                                ),
                              ),
                          ],
                        ),

                    ],
                  );
                }
              },
            )

          ],
        ),
      ),
    );
  }
}
class Category {
  final String id;
  final String name;
  final String picture;

  Category({
    required this.id,
    required this.name,
    required this.picture
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      picture: json['picture']
    );
  }
}
Future<List<Product>> fetchProductsByCategory(String categoryId) async {
  final response = await http.get(Uri.parse(global.url+'/products/category/'+categoryId));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    final List<Product> products = data.map((item) => Product.fromJson(item)).toList();
    return products;
  } else {
    throw Exception('Failed to fetch products by category');
  }
}
class CategoryTile extends StatelessWidget {
  final BuildContext context;
  final Category category;


  CategoryTile({
    required this.context,
    required this.category,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var data = await fetchProductsByCategory(category.id);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => ProductDisplayPage(products: data, appBarTitle: category.name)));
      },
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: tColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0x90cf4055), width: 8),
              image: DecorationImage(
                image: NetworkImage(global.url+ category.picture),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color(0xffcf4055),
            ),
          ),
        ],
      ),
    );
  }
}
