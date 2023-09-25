import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/global.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/global.dart';

class Vet {
  final String phone;
  final String name;
  final String email;
  final String address;
  final String pincode;
  final String picture;

  Vet({
    required this.phone,
    required this.name,
    required this.email,
    required this.address,
    required this.pincode,
    required this.picture,
  });

  factory Vet.fromJson(Map<String, dynamic> json) {
    return Vet(
      phone: json['phone'] ?? '',
      name: json['name'],
      email: json['email'],
      address: json['address'],
      pincode: json['pincode'],
      picture: json['picture'] ,
    );
  }
}

class VetService {
  static Future<List<Vet>> fetchVets() async {
    final response = await http.get(Uri.parse(global.url + '/get_vet'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Vet> vets = jsonData.map((data) => Vet.fromJson(data)).toList();
      print(vets);
      return vets;
    } else {
      throw Exception('Failed to load vet details');
    }
  }
}

void main() async {
  final List<Vet> vets = await VetService.fetchVets();

}
