import 'package:appiot/home_screen.dart';
import 'package:appiot/list_device_on.dart';
import 'package:appiot/model/load_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class RoomDetail extends StatefulWidget {
  const RoomDetail({Key? key, required this.Id, required this.Name}) : super(key: key);
  final String Id;
  final String Name;

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  List<Device> _devicesInRoom = [];
   
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // print(" Id: ${widget.Id}");
    List<Device> devicesInRoom = await RoomInfo.loadDevicesInRoom(widget.Id);
    setState(() {
      // print("device:$devicesInRoom");
      _devicesInRoom = devicesInRoom;
      
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Danh sách thiết bị trong phòng: ${_devicesInRoom.length}", style: TextStyle(fontSize: 20)),
        
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _devicesInRoom.length,
              itemBuilder: (BuildContext context, int index) {
                return Hero(
                  tag: 'device_hero_${_devicesInRoom[index].id}',
                child: ListDeviceON(deviceReference: FirebaseDatabase.instance.ref().child('device').child(_devicesInRoom[index].id.toString()),));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _devicesInRoom.clear();
  }
}
