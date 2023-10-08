import 'package:flutter/material.dart';
import 'package:frontend/Screens/shop_home/components/cart.dart';
import 'package:frontend/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final int productId;
  final int quantity;

  OrderItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }
}

class OrderScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;

  OrderScreen({required this.cartItems, required this.total});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // API endpoint URL for placing an order


  Future<void> placeOrder(List<CartItem> cartItems) async {
    // Prepare the order data
    final String placeOrderUrl = global.url + '/place-order/9980653944/'+widget.total.toString();
    final orderItems = cartItems.map((item) {
      return {
        'id': item.id, // Replace with the appropriate field for product ID
        'price': item.price, // Replace with the appropriate field for product price
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaymentMethodScreen(cartItems: widget.cartItems, orderId: response.body),
        ),
      );
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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Order Summary:'),
            for (var item in widget.cartItems)
              Text('Product ID: ${item.id}, Quantity: ${item.quantity}'),
            ElevatedButton(
              onPressed: () {
                // Place the order when the button is pressed
                placeOrder(widget.cartItems);
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final String orderId;

  PaymentMethodScreen({required this.cartItems, required this.orderId});

  // Implement the payment method screen UI and logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Choose Payment Method:'),
            // Implement payment method selection UI here

            ElevatedButton(
              onPressed: () {
                // Complete the order and mark it as paid
                completeOrder(context);
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> completeOrder(BuildContext context) async {

}}
