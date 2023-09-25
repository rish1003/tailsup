import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/global.dart';

class CreatePetPage extends StatefulWidget {
  @override
  _CreatePetPageState createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController specialNeedsController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> chooseImage() async {
    var picker = ImagePicker();
    var choosedimage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (choosedimage != null) {
        _image = File(choosedimage.path);
      }
      else{
        _image = File("assets/logo.png");
      }
    });
  }





  Future<void> _uploadPet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('Phone');
    var url = Uri.parse(global.url+'/createpet/'+ph!.substring(3)); // Replace with your API URL

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'name': nameController.text,
      'breed': breedController.text,
      'age': ageController.text,
      'weight': weightController.text,
      'special_needs': specialNeedsController.text,
      'gender': genderController.text,
      'description': descriptionController.text,
    });

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('picture', _image!.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Pet created successfully');
      // Handle success, e.g., show a success message or navigate to another page
    } else {
      print('what');
      print('Failed to create pet: ${response.reasonPhrase}');
      // Handle the error, e.g., show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Pet'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: chooseImage,
              child: _image != null
                  ? Image.file(_image!)
                  : Container(
                width: 150,
                height: 150,
                color: Colors.grey[200],
                child: Icon(Icons.add_a_photo, size: 48.0),
              ),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: breedController,
              decoration: InputDecoration(labelText: 'Breed'),
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight'),
            ),
            TextFormField(
              controller: specialNeedsController,
              decoration: InputDecoration(labelText: 'Special Needs'),
            ),
            TextFormField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadPet,
              child: Text('Create Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
