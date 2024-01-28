import 'dart:convert';
import 'package:http/http.dart' as http;
class WeatherInfo {
  final Map<String, dynamic> weatherData;
  final String cityName;

  WeatherInfo(this.weatherData, this.cityName);
}

class WeatherApi {
  final String apiKey;
  final String baseUrl;

  WeatherApi(this.apiKey, this.baseUrl);

  Future<WeatherInfo> getWeatherInfo(String city) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final cityName = jsonData['name']; // Lấy tên thành phố từ dữ liệu thời tiết
        final weatherInfo = WeatherInfo(jsonData, cityName);
        return weatherInfo;
      } else {
        throw Exception('Failed to load weather information');
      }
    } catch (e) {
      throw Exception('Failed to connect to the weather API');
    }
  }

  Future<String> getTemperatureWithTimeZone(String city) async {
    try {
      final weatherInfo = await getWeatherInfo(city);

      final temperatureKelvin = weatherInfo.weatherData['main']['temp'];
      final temperatureCelsius = _convertKelvinToCelsius(temperatureKelvin.toDouble());

      final isDayTime = _isDayTime(weatherInfo.weatherData['weather'][0]['icon']);

      return 'Thành phố: ${weatherInfo.cityName} Nhiệt độ: $temperatureCelsius °C, ${isDayTime ? 'Ban ngày' : 'Ban đêm'}';
      
    } catch (e) {
      throw Exception('Failed to retrieve temperature and timezone information');
    }
  }

  bool _isDayTime(String iconCode) {
    return iconCode.contains('d');
  }

  double _convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}
