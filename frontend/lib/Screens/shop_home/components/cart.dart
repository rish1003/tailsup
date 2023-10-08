import 'package:flutter/material.dart';
import 'package:frontend/Screens/shop_home/components/prod_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../orderscreen.dart';

class ShoppingCartDialog extends StatefulWidget {
  @override
  _ShoppingCartDialogState createState() => _ShoppingCartDialogState();
}

class _ShoppingCartDialogState extends State<ShoppingCartDialog> {
  List<CartItem> localCartItems = [];
  List<CartItem> updatedCartItems = []; // Store changes to update the database
  double totalPrice = 0.0;
  Future<void> updateCartInDatabase(List<CartItem> updatedCartItems) async {
    print(updatedCartItems);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone');
    final String apiUrl = global.url +
        '/cart/update/' +
        ph!.substring(3); // Replace with your API endpoint URL

    final List<Map<String, dynamic>> updatedCartItemsData = updatedCartItems
        .map((item) => {
              'id': item
                  .id, // Replace with the unique identifier for each cart item
              'quantity': item.quantity,
            })
        .toList();

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
        // Handle error (e.g., server error or network issues)
        print(
            'Failed to update cart items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      print('Error while updating cart items: $e');
    }
  }

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone');
    final response = await http.get(Uri.parse(
        global.url + '/cart/' + ph!.substring(3))); // Pass the user's ID

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<CartItem> items =
          data.map((item) => CartItem.fromJson(item)).toList();

      setState(() {
        localCartItems = items;
        totalPrice = calculateTotalPrice(localCartItems);
      });
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  double calculateTotalPrice(List<CartItem> items) {
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addToCart(int index) {
    setState(() {
      localCartItems[index].quantity++;
      totalPrice = calculateTotalPrice(localCartItems);
    });
  }

  void removeFromCart(int index) {
    setState(() {
      if (localCartItems[index].quantity > 1) {
        localCartItems[index].quantity--;
      } else {
        // Remove the item from the cart if the quantity is 1 or less
        localCartItems.removeAt(index);
      }
      totalPrice = calculateTotalPrice(localCartItems);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Your Cart",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color(0xffcf4055),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (localCartItems.isEmpty)
            Text("Your cart is empty.")
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: localCartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(localCartItems[index].productName),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "₹${localCartItems[index].price.toStringAsFixed(2)}"),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              removeFromCart(index); // Decrement quantity
                            },
                          ),
                          Text(localCartItems[index].quantity.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              addToCart(index); // Increment quantity
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          SizedBox(height: 16),
          Text(
            "Total: ₹${totalPrice.toStringAsFixed(2)}",
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xffcf4055),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              updatedCartItems = localCartItems;
              await updateCartInDatabase(updatedCartItems);

              final String placeOrderUrl = global.url +
                  '/place-order/9980653944/' +
                  totalPrice.toString();
              final orderItems = updatedCartItems.map((item) {
                return {
                  'id': item
                      .id, // Replace with the appropriate field for product ID
                  'price': item
                      .price, // Replace with the appropriate field for product price
                  'quantity': item.quantity,
                };
              }).toList();

              final orderData = {
                'order_items': orderItems,
              };

              // Make a POST request to place the order
              final response = await http.post(
                Uri.parse(placeOrderUrl),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: json.encode(orderData),
              );
              print(response.body);

              if (response.statusCode == 200) {
                // Order successfully created, navigate to the payment method screen
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Order Completed"),
                        content:
                            Text("Your order has been successfully completed."),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context)
                                  .pop(); // Navigate back to the main page
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    });
              } else {
                // Handle error, e.g., display an error message
                final errorMessage = json.decode(response.body)['error'];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: Text("Proceed to Checkout"),
          ),
          SizedBox(height: 16), // Added space before the close button
          ElevatedButton(
            onPressed: () async {
              updatedCartItems = localCartItems;

              await updateCartInDatabase(updatedCartItems);

              // Close the dialog
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String id;
  final String productName;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['product_name'],
      price: double.parse(json['product_price']),
      quantity: json['quantity'],
      id: json['id'].toString(),
    );
  }
}
