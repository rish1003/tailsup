import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/global.dart';
class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<NewOrder> pastOrders = [];
  List<NewOrder> upcomingOrders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    // Replace with your API endpoint URL to fetch orders
    final apiUrl = global.url+'/get_orders/9980653944';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Separate past and upcoming orders based on the 'status' field
        for (var orderData in data) {
          final NewOrder order = NewOrder.fromJson(orderData);

          if (order.status == true) {
            pastOrders.add(order);
          } else {
            upcomingOrders.add(order);
          }
        }

        // Refresh the UI
        setState(() {});
      } else {
        // Handle error
        print('Failed to fetch orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error while fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.add,color: Colors.grey[200]),
          backgroundColor: Colors.grey[200],
          bottom: TabBar(
            indicatorColor: Color(0xffcf4055),
            labelColor: Color(0xffcf4055),
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(upcomingOrders),
            _buildOrdersList(pastOrders),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<NewOrder> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text('No orders found'),
      );
    } else {
      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            // Customize the card UI for order details
            child: ListTile(
              title: Text('Order ID: ${order.id}'),
              subtitle: Text('Total: ${order.total}'),
              // Add more order details as needed
            ),
          );
        },
      );
    }
  }
}

class NewOrder {
  final int id;
  final String userId;
  final String total;
  final bool status;

  NewOrder({
    required this.id,
    required this.userId,
    required this.total,
    required this.status,
  });

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      id: json['id'],
      userId: json['userid'],
      total: json['total'],
      status: json['status'],
    );
  }
}
