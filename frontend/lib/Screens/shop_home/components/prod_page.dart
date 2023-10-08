import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';
class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  final String id;

  int quantity;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl, required String this.id, this.quantity = 1,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString() ?? "", // Assuming 'id' is an integer in the API response
      name: json['name'],
      price: double.parse(json['price'].toString()), // Parsing the price as a double
      imageUrl: json['picture'], description:  json['description'],
    );
  }
}

class ProductDisplayPage extends StatefulWidget {
  final List<Product> products;
  final String appBarTitle;

  ProductDisplayPage({
    required this.products,
    required this.appBarTitle,
  });

  @override
  State<ProductDisplayPage> createState() => _ProductDisplayPageState();
}

class _ProductDisplayPageState extends State<ProductDisplayPage> {
  List<CartItem> localCartItems = [];
  List<CartItem> updatedCartItems = [];

  Future<void> addToCart(Product product) async {
  setState(() {
  final existingCartItemIndex = localCartItems.indexWhere(
  (item) => item.id == product.id,
  );


  if (existingCartItemIndex != -1) {
  localCartItems[existingCartItemIndex].quantity++;
  } else {

  final newCartItem = CartItem(
  quantity: 1, id: product.id, productName: product.name, price: product.price,
  );
  localCartItems.add(newCartItem);
  print(localCartItems);
  }

  // Update the database here by calling the API to update the cart
  updatedCartItems = localCartItems;
  updateCartInDatabase(localCartItems);
  });
  }

  Future<void> removeFromCart(Product product) async {
  setState(() {
  final existingCartItemIndex = localCartItems.indexWhere(
  (item) => item.id == product.id,
  );

  if (existingCartItemIndex != -1) {
  if (localCartItems[existingCartItemIndex].quantity > 1) {
  localCartItems[existingCartItemIndex].quantity--;
  } else {
  localCartItems.removeAt(existingCartItemIndex);
  }

  // Update the database here by calling the API to update the cart
  updatedCartItems = localCartItems;
  updateCartInDatabase(localCartItems);
  }
  });
  }

  Future<void> updateCartInDatabase(List<CartItem> updatedCartItems) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone');
    final String apiUrl = global.url + '/cart/update/' + ph!.substring(3);

    final List<Map<String, dynamic>> updatedCartItemsData = updatedCartItems
        .map((item) =>
    {
      'id': item.id,
      'quantity': item.quantity,
    })
        .toList();
    print(updatedCartItemsData);

    final Map<String, dynamic> requestBody = {
      'cart_items': updatedCartItemsData,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successfully updated the database
        final responseData = json.decode(response.body);
        print('Updated cart items: $responseData');
      } else {
        // Handle error
        print(
            'Failed to update cart items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error while updating cart items: $e');
    }}

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone');
    final response = await http.get(
        Uri.parse(global.url+'/cart/'+ph!.substring(3))); // Pass the user's ID

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<CartItem> items = data.map((item) => CartItem.fromJson(item)).toList();

      setState(() {
        localCartItems = items;
      });
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  void initState() {
    super.initState();
    fetchCartItems();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.medical_services,
              color: Color(0xff0d6b6a),
            ),
            SizedBox(width: 5.0),
            Text(
              widget.appBarTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff0d6b6a),
              ),
            ),

          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove app bar elevation
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two products per row
          childAspectRatio: 0.7, // Adjust this ratio for smaller tiles
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];

          return Card(
            elevation: 2.0,
            margin: EdgeInsets.all(8.0),
            child: Container(
              height: 220.0, // Increase tile height as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    global.url + product.imageUrl,
                    height: 100.0, // Adjust image height as needed
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0, // Decrease font size
                          ),
                        ),
                        SizedBox(height: 4.0), // Adjust spacing
                        Text(
                          '₹${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12.0, // Decrease font size
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.0), // Adjust spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          removeFromCart(product);
                        },
                      ),
                      Text('1'), // Display quantity (replace with actual quantity)
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          addToCart(product);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );


        },
      ),
    );
  }
}


