import 'package:http/http.dart' as http;
import 'dart:convert';

// void parseForecastResponse(Map<String, dynamic> jsonData) {
//   final items = jsonData["response"]?["body"]?["items"]?["item"];
//
//   if (items is List) {
//     for (final item in items) {
//       final String baseDate = item["baseDate"];
//       final String baseTime = item["baseTime"];
//       final String fcstTime = item["fcstTime"];
//       final String category = item["category"];
//       final String fcstValue = item["fcstValue"];
//
//       print("[baseDate=$baseDate baseTime=$baseTime] $fcstTime | $category → $fcstValue");
//     }
//   } else {
//     print("⚠️ 예보 항목이 없습니다.");
//   }
// }

// /// 내일 날짜를 'yyyyMMdd' 형식으로 반환
// String getBaseDate() {
//   final tomorrow = DateTime.now().add(Duration(days: 1));
//   return "${tomorrow.year.toString().padLeft(4, '0')}"
//       "${tomorrow.month.toString().padLeft(2, '0')}"
//       "${tomorrow.day.toString().padLeft(2, '0')}";
// }
//
// /// 고정된 시간 '0000' 반환
// String getBaseTime() {
//   return "0000";
// }

// Future<void> fetchForecast({
//   required String serviceKey,
//   required int nx,
//   required int ny,
// }) async {
//   final encodedKey = serviceKey;
//   final baseDate = getBaseDate(); // 내일
//   final baseTime = getBaseTime(); // "0000"
//
//   const pageNo = 1;
//   const numOfRows = 1000;
//   const dataType = "JSON";
//
//   final url =
//       'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst'
//       '?serviceKey=$encodedKey'
//       '&pageNo=$pageNo'
//       '&numOfRows=$numOfRows'
//       '&dataType=$dataType'
//       '&base_date=$baseDate'
//       '&base_time=$baseTime'
//       '&nx=$nx&ny=$ny';
//
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     final jsonData = jsonDecode(response.body);
//     print("✅ 예보 데이터 수신 성공");
//     print(jsonData); // 5번에서 파싱할 것
//   } else {
//     print("❌ 요청 실패: ${response.statusCode}");
//   }
// }
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