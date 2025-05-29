import 'dart:convert';
import 'package:http/http.dart' as http;
import 'address_to_gridxy_korea.dart';

String getBaseDate() {
  final today = DateTime.now();
  return "${today.year.toString().padLeft(4, '0')}"
      "${today.month.toString().padLeft(2, '0')}"
      "${today.day.toString().padLeft(2, '0')}";
}

String getBaseTime() {
  final now = DateTime.now();
  int hour = now.hour;
  // if (now.minute < 45) hour -= 1;
  if (hour < 0) hour = 23;
  return hour.toString().padLeft(2, '0') + "00";
}

// request 응답 변수 정리해서 출력함수
void parseForecastResponse(Map<String, dynamic> jsonData) {
  final items = jsonData["response"]?["body"]?["items"]?["item"];

  if (items is List) {
    for (final item in items) {
      final String baseDate = item["baseDate"];
      final String baseTime = item["baseTime"];
      final String fcstTime = item["fcstTime"];
      final String category = item["category"];
      final String fcstValue = item["fcstValue"];

      final baseHour = baseTime.substring(0, 2);
      final fcstHour = fcstTime.substring(0, 2);

      if (!["TMP", "PTY", "POP", "REH"].contains(category)) continue;


      // 항목별 설명 맵
      final descriptions = {
        "TMP": "기온(℃)",
        // "UUU": "동서바람(m/s)",
        // "VVV": "남북바람(m/s)",
        // "VEC": "풍향(°)",
        // "WSD": "풍속(m/s)",
        // "SKY": "하늘상태",
        "PTY": "강수형태",
        "POP": "강수확률(%)",
        // "WAV": "파고(m)",
        // "PCP": "1시간 강수량",
        "REH": "습도(%)",
        // "SNO": "1시간 신적설"
      };

      // SKY 코드 해석
      String interpretSky(String value) {
        return {
          "1": "맑음",
          "3": "구름많음",
          "4": "흐림"
        }[value] ?? "정보없음";
      }

      // PTY 코드 해석
      String interpretPty(String value) {
        return {
          "0": "없음",
          "1": "비",
          "2": "비/눈",
          "3": "눈",
          "4": "소나기"
        }[value] ?? "정보없음";
      }

      String label = descriptions[category] ?? category;
      String interpreted = fcstValue;

      if (category == "SKY") {
        interpreted = interpretSky(fcstValue);
      } else if (category == "PTY") {
        interpreted = interpretPty(fcstValue);
      }

      print("[$baseDate] ${baseHour}시 발표 / ${fcstHour}시 예보 → $label: $interpreted");
    }
  } else {
    print("⚠️ 예보 항목이 없습니다.");
  }
}

//fetchForecast
Future<List<Map<String, String>>> fetchForecast({
  required String serviceKey,
  required int nx,
  required int ny,
}) async {
  final encodedKey = serviceKey;
  final baseDate = getBaseDate();
  final baseTime = getBaseTime();

  const pageNo = 1;
  const numOfRows = 1000;
  const dataType = "JSON";

  final url =
      'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst'
      '?serviceKey=$encodedKey'
      '&pageNo=$pageNo'
      '&numOfRows=$numOfRows'
      '&dataType=$dataType'
      '&base_date=$baseDate'
      '&base_time=$baseTime'
      '&nx=$nx&ny=$ny';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final items = jsonData["response"]?["body"]?["items"]?["item"];

    if (items is List) {
      return items
          .where((item) =>
          ["TMP", "PTY", "POP", "REH"].contains(item["category"]))
          .map<Map<String, String>>((item) {
        final labelMap = {
          "TMP": "기온(℃)",
          "PTY": "강수형태",
          "POP": "강수확률(%)",
          "REH": "습도(%)"
        };
        final valueMap = {
          "0": "없음",
          "1": "비",
          "2": "비/눈",
          "3": "눈",
          "4": "소나기"
        };

        String category = item["category"];
        String value = item["fcstValue"];
        if (category == "PTY") {
          value = valueMap[value] ?? value;
        }
        return {
          "label": labelMap[category] ?? category,
          "value": value,
          "fcstTime": item["fcstTime"]
        };
      }).toList();
    }
  }

  return [];
}

void main() async {
  const serviceKey = "4TEeEbCQ7DrRqU1z1MlvSAIFG1Did9WbvUx8GJ6nquLWxEYz7%2BUqu2ToWCArhD4VXIiD3L4hrRHHEazI2I3pkA%3D%3D";

  String si = "서울특별시";
  String gu = "종로구";
  String dong = "청운효자동";

  final coords = addressToGridXY[si]?[gu]?[dong];

  if (coords == null) {
    print("⚠️ 격자 좌표를 찾을 수 없습니다.");
    return;
  }

  final forecast = await fetchForecast(
    serviceKey: serviceKey,
    nx: coords['x']!,
    ny: coords['y']!,
  );

  if (forecast.isEmpty) {
    print("📭 예보 데이터가 없습니다.");
  } else {
    print("✅ 예보 데이터 (${forecast.length}개):");
    for (final item in forecast) {
      print("${item["fcstTime"]}시 | ${item["label"]}: ${item["value"]}");
    }
  }
}
// void main() {
//   const apiKey = "4TEeEbCQ7DrRqU1z1MlvSAIFG1Did9WbvUx8GJ6nquLWxEYz7%2BUqu2ToWCArhD4VXIiD3L4hrRHHEazI2I3pkA%3D%3D"; // 여기에 진짜 키 넣기
//
//   String si = "경기도";
//   String gu = "수원시팔달구";
//   String dong = "화서1동";
//
//   final coords = addressToGridXY[si]?[gu]?[dong];
//   if (coords == null) {
//     print("⚠️ 격자 좌표를 찾을 수 없습니다.");
//
//     return;
//   }
//
//   final int nx = coords["x"]!;
//   final int ny = coords["y"]!;
//   fetchForecast(serviceKey: apiKey, nx: nx, ny: ny);
// }
