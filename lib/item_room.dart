
import 'package:appiot/model/load_data.dart';
import 'package:appiot/room_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ItemRoom extends StatefulWidget {
  const ItemRoom({super.key,required this.roomReference});

   final DatabaseReference roomReference;
  @override
  State<ItemRoom> createState() => _ItemRoomState();
}


class _ItemRoomState extends State<ItemRoom> {
 DatabaseReference roomReference = FirebaseDatabase.instance.ref().child('rooms');
 RoomInfo roominfo= RoomInfo(id: "0", name: "");
  @override
  Widget build(BuildContext context) {
     if (roominfo.id==0) {
      return CircularProgressIndicator();
    }
       return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => RoomDetail(Id:roominfo.id, Name: roominfo.name,)));},
        child:
        Container(     
          margin: EdgeInsets.all(10),
          width: (MediaQuery.of(context).size.width / 2) - 20,
          height: MediaQuery.of(context).size.width / 2 - 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 20, 79, 76),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [ 
                  Container(
                    width: MediaQuery.of(context).size.width/3 + 5,
                    height: MediaQuery.of(context).size.width/3,
                    child: 
                      Icon(getRoomIcon(roominfo.name),size: MediaQuery.of(context).size.width/5,color: Colors.grey,),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height/18,
                    child: 
                      Icon(Icons.arrow_forward_ios,size: MediaQuery.of(context).size.width/15, color: Colors.grey,),
                  )
                ],
              ),
              Text(
                roominfo.name,
                textAlign: TextAlign.center,
                style:const  TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  
                ),
              ),
            
            ],
          ),
        ),
      
    );
  }
   @override
  void initState() {
    super.initState();
    // roomReference.child('${widget.roomReference.key}').onValue.listen((event) {
    //   var snapshot = event.snapshot;
    //   setState(() {
    //     ledStatus = snapshot.value == "true" ? true : false;
    //   });
    // });
    loadDataFromFirebase1();
  }
 void loadDataFromFirebase1() async {
  // print("Load data from Firebase - roomID: ${widget.roomReference.key}");
  try {
    DatabaseEvent event = await widget.roomReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    if (dataSnapshot.value != null) {
      if (dataSnapshot.value is Map) {
        Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;
        // print("Data from Firebase: $data");
        String roomId = data["idroom"]?.toString() ?? "";

        setState(() {
          roominfo = RoomInfo.fromJson(roomId, data);
        });
      } else {}
    }
  } catch (e) {
    print("Error loading data: $e");
  }
}
}

IconData getRoomIcon(String roomName) {
  Map<String, IconData> roomIconMap = {
    'Phòng ngủ 1': Icons.bed,
    'Phòng ngủ 2': Icons.bed,
    'Phòng khách': Icons.tv,
    'Phòng sinh hoạt': Icons.living_outlined,
    'Nhà bếp': Icons.kitchen,
    'Nhà vệ sinh': Icons.bathtub,
  };
  if (roomIconMap.containsKey(roomName)) {
    return roomIconMap[roomName]!;
  } else {
 
    return Icons.error;
  }
}