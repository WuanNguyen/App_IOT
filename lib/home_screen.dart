import 'package:appiot/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'weather_api.dart';
import 'list_device_on.dart';
import 'model/load_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _databaseReference =FirebaseDatabase.instance.ref().child('device');
  List<Device> allDevices = [];
  List<Device> visibleDevices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() async {
    DatabaseEvent event = await _databaseReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? value = dataSnapshot.value as Map<dynamic, dynamic>?;

    List<Device> loadedDevices = [];
    if (value != null && value is Map) {
      for (var entry in value.entries) {
        loadedDevices.add(Device.fromJson(entry.key, entry.value));
      }
    } else {
      print("Data is null or not in the expected format");
    }

    setState(() {
      allDevices = loadedDevices;
      _updateVisibleDevices();
    });
  }

  Future<void> _updateVisibleDevices() async {
    await Future.delayed(Duration(milliseconds: 1)); 
    // Assuming you want to load all devices, whether onSwitch is true or false.
    visibleDevices = List.from(allDevices);
    // If you want to load only devices where onSwitch is true, use the line below:
    // visibleDevices = allDevices.where((device) => device.onSwitch).toList();
  }

  final WeatherApi weatherApi = WeatherApi(
      '778be07e1397832f5d23072158bcf963', 'https://api.openweathermap.org/data/2.5');
  final String cityName = 'SaiGon';

  @override
  Widget build(BuildContext context) {
    int count = (visibleDevices.length / 2).ceil();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
           Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0), 
                  bottomRight: Radius.circular(15.0),
                ),
              ),
              child: Center(
                child: WeatherScreen(weatherApi: weatherApi, cityName: cityName),
              ),
            ),
            // IconButton(onPressed: (){_loadDevices();}, icon: Icon(Icons.refresh)),
            Expanded(
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  if (visibleDevices.length % 2 != 0 && index == count - 1) {
                    return Row(
                      children: [
                        ListDeviceON(
                          deviceReference: FirebaseDatabase.instance
                              .ref()
                              .child('device')
                              .child(visibleDevices[index * 2].id.toString()),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        ListDeviceON(
                          deviceReference: FirebaseDatabase.instance
                              .ref()
                              .child('device')
                              .child(visibleDevices[index * 2].id.toString()),
                        ),
                        ListDeviceON(
                          deviceReference: FirebaseDatabase.instance
                              .ref()
                              .child('device')
                              .child(visibleDevices[index * 2 + 1].id.toString()),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateData() {}
}
