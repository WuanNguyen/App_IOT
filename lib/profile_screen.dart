import 'dart:async';
import 'package:appiot/EditProflie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appiot/displayImage.dart';
import 'package:appiot/model/load_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DatabaseReference userReference = FirebaseDatabase.instance.ref().child('users');
  List<User> _users = [];

  void _loadUsers() async {
    DatabaseEvent event = await userReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? value = dataSnapshot.value as Map<dynamic, dynamic>?;

    List<User> loadedUsers = [];
    if (value != null && value is Map) {
      value.forEach((key, value) {
        User? user = User.fromJson(key, value);
        if (user != null) {
          loadedUsers.add(user);
        }
      });
    } else {
      print("Data is null or not in the expected format");
    }

    setState(() {
      _users = loadedUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
  void reloadUserData() {
    _loadUsers();
  }

  void _updateImage(String imagePath, User user) async {
    user.image = imagePath;
    await userReference.child(user.id).update({'image': imagePath});
    setState(() {});
  }
  void _showEditProfileDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return EditProfileForm(user: user, reloadUserDataCallback: reloadUserData,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_users.isEmpty) {
      return CircularProgressIndicator();
    }
    User user = _users[0];
    return Column(
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
        ),
        InkWell(
          onTap: () {
            _pickImage(user);
          },
          child: DisplayImage(
            imagePath: user.image,
            onPressed: () {
             
            },
          ),
        ),
        const SizedBox(height: 20),
        buildUserInfoDisplay(user.username, 'Name', (){
          _showEditProfileDialog(context, user);
        } ),
        buildUserInfoDisplay(user.phone, 'Phone',(){
          _showEditProfileDialog(context, user);
        }),
        buildUserInfoDisplay(user.email, 'Email',(){
          _showEditProfileDialog(context, user);
        }),
      ],
    );
  }

 Widget buildUserInfoDisplay(
  String getValue,
  String title,
  VoidCallback onPressedCallback,
) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 350,
            height: 50,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onPressedCallback,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title:',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 65,
                        ),
                        Text(
                          getValue,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );


  Future<void> _pickImage(User user) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _updateImage(pickedFile.path, user);
    }
  }
}
