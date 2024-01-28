import 'dart:io';

import 'package:appiot/about_screen.dart';
import 'package:appiot/displayImage.dart';
import 'package:appiot/login_screen.dart';
import 'package:appiot/model/load_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  State<MyDrawer> createState() => _DrawerState();
}
class _DrawerState extends State<MyDrawer> {
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
  @override
  Widget build(BuildContext context) {
    if (_users.isEmpty) {
      return CircularProgressIndicator();
    }
     User user = _users[0];
    return Drawer(
      child: Column(
        
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 254, 222, 175)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 55, // Adjust the radius as needed
                      backgroundImage: FileImage(File(user.image)),
                    ),
                  ),
                Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Cài đặt'),
            onTap: () {
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text('Lợi ích'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BenifitScreen()),
              );
            },
          ),
          Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Đăng xuất',style: TextStyle(color: Colors.red, fontSize: 17),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

