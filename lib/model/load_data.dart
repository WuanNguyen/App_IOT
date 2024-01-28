import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

class BoardInfo {
  String id;
  String pin;

  BoardInfo({
    required this.id,
    required this.pin,
  });

  factory BoardInfo.fromJson(Map<dynamic, dynamic> json) {
    return BoardInfo(
      id: json['idboard'] ?? "",
      pin: json['pin'] ?? "",
    );
  }
}

class RoomInfo {
  String id;
  String name;

  RoomInfo({
    required this.id,
    required this.name,
  });

  factory RoomInfo.fromJson(String id,Map<dynamic, dynamic> json) {
    return RoomInfo(
      id: id,
      name: json['nameroom'] ?? "",
    );
  }

  static DatabaseReference getRoomReference() {
    return FirebaseDatabase.instance.ref().child('rooms');
  }

  static Future<List<RoomInfo>> fetchRoom() async {
    DatabaseReference roomReference = getRoomReference();
    DatabaseEvent event = await roomReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? value = dataSnapshot.value as Map<dynamic, dynamic>?;

    List<RoomInfo> _rooms = [];
    if (value != null) {
      value.forEach((key, value) {
        _rooms.add(RoomInfo.fromJson(key,value));
      });
    }

    return _rooms;
  }
  static Future<List<Device>> loadDevicesInRoom(String roomId) async {
    DatabaseReference devicesReference = FirebaseDatabase.instance.ref().child('device');
    DatabaseEvent event = await devicesReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;

    List<Device> devicesInRoom = [];
    if (values != null) {
      values.forEach((key, value) {
        Device device = Device.fromJson(key, value);
        if (device.roomId == roomId) {
          devicesInRoom.add(device);
        }
      });
    }

    return devicesInRoom;
  }
}

class Device {
  String id;
  BoardInfo board;
  String roomId;
  String name;
  bool onSwitch;

  Device({
    required this.id,
    required this.board,
    required this.roomId,
    required this.name,
    required this.onSwitch,
    
  });

  factory Device.fromJson(String id, Map<dynamic, dynamic> json) {
    return Device(
      id: id,
      board: BoardInfo.fromJson(json['board'] ?? {}),
      roomId: json['idroom'] ?? "",
      name: json['namedevice'] ?? "",
      onSwitch: json['onswitch'] ?? false,
     
    );
  }

  static DatabaseReference getDevicesReference() {
    return FirebaseDatabase.instance.ref().child('device');
  }

  static Future<List<Device>> fetchDevices() async {
    DatabaseReference devicesReference = getDevicesReference();
    DatabaseEvent event = await devicesReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;

    List<Device> devices = [];
    if (values != null) {
      values.forEach((key, value) {
        devices.add(Device.fromJson(key, value));
      });
    }

    return devices;
  }
   
}


class User {
  String username;
  String image;
  String email;
  String phone;
  String id;

  User({
    required this.id,
    required this.username,
    required this.phone,
    required this.image,
    required this.email,
  });

  factory User.fromJson(String id, Map<dynamic, dynamic> json) {
    return User(
      id: id,
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      image: json['image'] ?? "",
    );
  }

  static DatabaseReference getUserReference() {
    return FirebaseDatabase.instance.ref().child('users');
  }

  static Future<List<User>> fetchUsers() async {
    DatabaseReference userReference = getUserReference();
    DatabaseEvent event = await userReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;

    List<User> users = [];
    if (values != null) {
      values.forEach((key, value) {
        users.add(User.fromJson(key, value));
  
      });
    }

    return users;
  }

 
  Future<void> updateInformation(String newUsername, String newPhone, String newEmail) async {
    DatabaseReference userReference = FirebaseDatabase.instance.ref().child('users').child(id);
    await userReference.update({
      'username': newUsername,
      'phone': newPhone,
      'email': newEmail,
    });
    
  }
   Future<void> reloadFromFirebase() async {
    try {
      // Fetch the latest data from Firebase
      DatabaseEvent event = await FirebaseDatabase.instance.ref().child('users').child(id).once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null && dataSnapshot.value is Map) {
        Map<dynamic, dynamic> userData = dataSnapshot.value as Map<dynamic, dynamic>;
        
        // Update the user properties with the latest data
        username = userData['username'] ?? '';
        phone = userData['phone'] ?? '';
        email = userData['email'] ?? '';
        // ... update other properties if needed
      } else {
        print("Data is null or not in the expected format");
      }
    } catch (e) {
      print("Error reloading data: $e");
    }
  }
  
}

 

