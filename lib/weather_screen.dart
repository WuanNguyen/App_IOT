import 'dart:async';
import 'package:flutter/material.dart';
import 'weather_api.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherApi weatherApi;
  final String cityName;

  const WeatherScreen({Key? key, required this.weatherApi, required this.cityName}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late TimeOfDay currentTime;
  late String period;
  bool autoUpdate = true;
  late Timer timer;
  late String weatherIcon; // Thêm biến để lưu trữ biểu tượng thời tiết
  late String cityName; // Thêm biến để lưu trữ tên thành phố

  @override
  void initState() {
    super.initState();

    // Khởi tạo giờ và phút ban đầu
    DateTime now = DateTime.now();
    currentTime = TimeOfDay.fromDateTime(now);
    period = currentTime.period == DayPeriod.am ? 'AM' : 'PM';

    // Bắt đầu tự động cập nhật
    // startAutoUpdate();
  }

  void startAutoUpdate() {
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateCurrentTime();
    });
  }

  void updateCurrentTime() {
    DateTime now = DateTime.now();
    setState(() {
      currentTime = TimeOfDay.fromDateTime(now);
      period = currentTime.period == DayPeriod.am ? 'AM' : 'PM';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // Gọi hàm cập nhật thời gian khi người dùng nhấn nút
              updateCurrentTime();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
            ),
            icon: Icon(
              Icons.refresh,
              color: Color.fromARGB(255, 66, 13, 13),
            ),
          ),
          SizedBox(width: 30, height: 15),
          Container(
            child: FutureBuilder<WeatherInfo>(
              future: widget.weatherApi.getWeatherInfo(widget.cityName),
              builder: (context, AsyncSnapshot<WeatherInfo> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  cityName = snapshot.data!.cityName; // Lấy tên thành phố từ WeatherInfo
                  final temperatureKelvin = snapshot.data!.weatherData['main']['temp'];
                  final temperatureCelsius = _convertKelvinToCelsius(temperatureKelvin.toDouble());

                  // Lấy mã biểu tượng thời tiết từ API
                  final weatherIconCode = snapshot.data!.weatherData['weather'][0]['icon'];

                  // Xác định biểu tượng thời tiết là ban ngày hay ban đêm
                  weatherIcon = _isDayTime(weatherIconCode) ? 'day' : 'night';
                 return Row(
                     children:[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          
                          children: [
                            Row(
                              children: [
                                Text(
                              '$cityName',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 20, 79, 76),
                              ),
                            ),
                            ],
                            ),
                            SizedBox(height: 2,),
                            Row(
                              children: [
                                Text('Nhiệt độ: ${temperatureCelsius.toStringAsFixed(2)}°C',
                                style: const TextStyle(color: Color.fromARGB(255, 20, 79, 76), fontSize: 17),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                              'Thời gian: ${currentTime.hourOfPeriod}:${currentTime.minute} $period',
                              style: const TextStyle(
                              color: Color.fromARGB(255, 20, 79, 76), fontSize: 17,
                              ),
                            ),
                          
                              ],
                            ),
                    
                          ],
                        ),
                        SizedBox(width: 20,),
                        Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset('assets/img/$weatherIcon.png', width: 100, height: 100),
                          ],
                        )
                     ],
                  );

                }
              },
            ),
          )
        ],
      ),
    );
  }

  double _convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  bool _isDayTime(String iconCode) {
    // Assume that if the icon code contains 'd' (day), it's daytime; otherwise, it's nighttime.
    return iconCode.contains('d');
  }

  @override
  void dispose() {
    // Hủy bỏ timer khi widget bị dispose để tránh rò rỉ bộ nhớ
    timer.cancel();
    super.dispose();
  }
}
