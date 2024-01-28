import 'package:appiot/item_room.dart';
import 'package:appiot/model/load_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {

  final DatabaseReference _databaseReference =FirebaseDatabase.instance.ref().child('rooms');
   List<RoomInfo> _rooms = [];

  void _loadRooms() async {
  DatabaseEvent event = await _databaseReference.once();
  DataSnapshot dataSnapshot = event.snapshot;
  Map<dynamic, dynamic>? value = dataSnapshot.value as Map<dynamic, dynamic>?;

 List<RoomInfo> loadedRooms = [];
    if (value != null && value is Map) {
      value.forEach((key, value) {
        RoomInfo? room = RoomInfo.fromJson(key,value);
        if (room != null) {
          loadedRooms.add(room);
        }
      });
    } else {
      print("Data is null or not in the expected format");
    }

  setState(() {
   _rooms = loadedRooms; 
      });
    }
   @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {

    int count = (_rooms.length / 2).ceil();
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          if (_rooms.length % 2 != 0 && index == count - 1) {
              return Row(children: [ItemRoom( roomReference: FirebaseDatabase.instance.ref().child('rooms').child(_rooms[index*2].id.toString()))]);
            } else {
              return Row(children: [
                ItemRoom( roomReference: FirebaseDatabase.instance.ref().child('rooms').child(_rooms[index*2].id.toString())) ,
                ItemRoom( roomReference: FirebaseDatabase.instance.ref().child('rooms').child(_rooms[index*2 +1 ].id.toString()))
              ]);
            }
        }
      ),
    );
  }

  
}