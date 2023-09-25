import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/global.dart';

class Pet {
  final String petId;
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String specialNeeds;
  final String gender;
  final String description;
  final String picture;
  final String shelter;


  Pet({
    required this.petId,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.specialNeeds,
    required this.gender,
    required this.description,
    required this.picture,
    required this.shelter,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json['pet_id'].toString(), // Ensure pet_id is treated as a string
      shelter: json['shelterid'] ?? '',
      name: json['name'],
      breed: json['breed'],
      age: json['age'].toString(), // Ensure age is treated as a string
      weight: json['weight'].toString(), // Ensure weight is treated as a string
      specialNeeds: json['special_needs'] ?? '', // Handle null value
      gender: json['gender'],
      description: json['description'],
      picture: json['picture'],
    );
  }

}

class PetShelter {
  static Future<List<Pet>> fetchPets() async {
    final response = await http.get(Uri.parse((global.url) + '/pets/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Pet> pets = jsonData.map((data) => Pet.fromJson(data))
          .toList();
      print(pets);
      return pets;
    } else {
      throw Exception('Failed to load pet details');
    }
  }

  static Future<List<Pet>> fetchFavPets() async {
    String? ph = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ph = prefs.getString('Phone');
    final response = await http.get(
        Uri.parse((global.url) + '/favorite_pets/' + ph!.substring(3)));


    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Pet> pets = jsonData.map((data) => Pet.fromJson(data))
          .toList();
      print(pets);
      return pets;
    } else {
      throw Exception('Failed to load pet details');
    }
  }

  static Future<List> fetchLikedPets() async {
    String? ph = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ph = prefs.getString('Phone');
    final response = await http.get(
        Uri.parse((global.url) + '/favoritepetids/' + ph!.substring(3)));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return (jsonData['favorite_pet_ids']);
    } else {
      throw Exception('Failed to load pet details');
    }
  }
}

void main() async {
  final List<Pet> pets = await PetShelter.fetchPets();

  // Iterate through the list of pets and retrieve values

}
