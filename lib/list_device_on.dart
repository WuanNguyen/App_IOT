import 'package:appiot/model/load_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ListDeviceON extends StatefulWidget {
  const ListDeviceON({super.key, required this.deviceReference});
  final DatabaseReference deviceReference;
 

  @override
  State<ListDeviceON> createState() => _ListDeviceONState();
}

class _ListDeviceONState extends State<ListDeviceON> {
  bool ledStatus = false;
  Device device = Device(
    id: "0",
    board: BoardInfo(id: "", pin: ""),
    roomId: "",
    name: "",
    onSwitch: false,
  );
   
  @override
  Widget build(BuildContext context) {
    
    if (device.id == "0") {
      return CircularProgressIndicator();
    }
    return Container(
      margin: EdgeInsets.all(10),
      width: (MediaQuery.of(context).size.width / 2) - 20,
      height: MediaQuery.of(context).size.height / 4 - 20,
      decoration: BoxDecoration(
        color: device.onSwitch ? Color.fromARGB(255, 84, 172, 245) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb,
                color: device.onSwitch ? Colors.yellow : const Color.fromARGB(255, 233, 232, 232),
                size: 80,
              ),
              Switch(
                value: device.onSwitch,
                activeColor: Colors.greenAccent,
                onChanged: (bool value) {
                  setState(() {
                    device.onSwitch = value;
                  });
                  _updateFirebaseStatus(value);
                },
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            device.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
          Text(
            getNameRoom(device.roomId),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
        
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.deviceReference.child('${widget.deviceReference.key}').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        ledStatus = snapshot.value == "true" ? true : false;
      });
    });
   
    loadDataFromFirebase();
  }

  void loadDataFromFirebase() async {
    try {
      DatabaseEvent event = await widget.deviceReference.once();
      DataSnapshot dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        if (dataSnapshot.value is Map) {
          Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;
          setState(() {
            device = Device.fromJson(widget.deviceReference.key!, data);
          });
        } else {}
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> _updateFirebaseStatus(bool status) async {
    await widget.deviceReference.update({'onswitch': status});
  }
 String getNameRoom(String id) {
  String nameroom;
  switch (id) {
    case "1":nameroom = "Phòng ngủ 1";
      break;
    case "2": nameroom = "Phòng ngủ 2";
      break;
    case "3":
      nameroom = "Phòng khách";
      break;
    case "4":
      nameroom = "Phòng sinh hoạt";
      break;
    case "5":
      nameroom = "Nhà bếp";
      break;
    case "6":
      nameroom = "Nhà vệ sinh";
      break;
    default:
      nameroom = "";
  }

  return nameroom;
}
}
     
  
   

  

