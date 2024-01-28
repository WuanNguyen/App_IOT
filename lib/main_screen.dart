import 'package:appiot/drawer.dart';
import 'package:appiot/home_screen.dart';
import 'package:appiot/profile_screen.dart';
import 'package:appiot/room_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Image.asset('assets/img/h1.jpg', fit: BoxFit.fill),
          toolbarHeight: 150,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
          IconButton(
            onPressed: () {
              
            },
            icon: const Icon(Icons.settings, color: Colors.black ),
           ),
          ],
      ), 
      drawer: const MyDrawer(),
      body: IndexedStack(
        children: [
          HomeScreen(),
          RoomScreen(),
          Profile(),
        ],
        index: _selectedIndex,
      ),
     bottomNavigationBar:BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.window),
            label: 'Phòng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cá nhân',
          ),
        ],
        backgroundColor: Colors.grey[100],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (value) {
          if (value != _selectedIndex) {
            setState(() {
              _selectedIndex = value;
            });
          }
        },
      ),
      
    );
  }
}