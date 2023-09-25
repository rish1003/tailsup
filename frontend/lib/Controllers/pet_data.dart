import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/global.dart';

class Pet {
  final int petId;
  final String userId;
  final String shelterId;
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String specialNeeds;
  final String gender;
  final String description;
  final String picture;

  Pet({
    required this.petId,
    required this.userId,
    required this.shelterId,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.specialNeeds,
    required this.gender,
    required this.description,
    required this.picture,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json['pet_id'],
      userId: json['userid'],
      shelterId: json['shelterid'] ?? '',
      name: json['name'],
      breed: json['breed'],
      age: json['age'],
      weight: json['weight'],
      specialNeeds: json['special_needs'] ?? '', // Handle null value
      gender: json['gender'],
      description: json['description'],
      picture: json['picture'],
    );
  }
}

class PetService {
  static Future<List<Pet>> fetchPets() async {

    String? ph = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ph = prefs.getString('Phone');
    print(ph);
    final response = await http.get(Uri.parse((global.url)+'/petdetails/'+ph!.substring(3)));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Pet> pets = jsonData.map((data) => Pet.fromJson(data)).toList();
      print( pets);
      return pets;
    } else {
      throw Exception('Failed to load pet details');
    }
  }
}

void main() async {
  final List<Pet> pets = await PetService.fetchPets();

  // Iterate through the list of pets and retrieve values
  for (final pet in pets) {
    print('Pet ID: ${pet.petId}');
    print('User ID: ${pet.userId}');
    print('Shelter ID: ${pet.shelterId}');
    print('Name: ${pet.name}');
    print('Breed: ${pet.breed}');
    print('Age: ${pet.age}');
    print('Weight: ${pet.weight}');
    print('Special Needs: ${pet.specialNeeds}');
    print('Gender: ${pet.gender}');
    print('Description: ${pet.description}');
    print('Photo: ${pet.picture}');
    print('-------------------');
  }
}
