import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  final String weatherUrl;
  Network(this.weatherUrl);

  Future<dynamic> getWeatherData() async {
    http.Response response = await http.get(Uri.parse(weatherUrl));
    if(response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData); //json형식 문자열을 배열 또는 객체로 변환하는 함수
      return parsingData;
    }
  }

}