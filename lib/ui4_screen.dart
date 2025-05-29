import 'package:flutter/material.dart';
import 'xyTest.dart'; // 같은 lib 폴더라 경로만 파일명
import 'address_to_gridxy_korea.dart';

class UI4Screen extends StatefulWidget {
  const UI4Screen({Key? key}) : super(key: key);

  @override
  State<UI4Screen> createState() => _UI4ScreenState();
}

class _UI4ScreenState extends State<UI4Screen> {
  late Future<List<Map<String, String>>> forecastData;

  @override
  void initState() {
    super.initState();

    // 예보 위치 지정
    final coords = addressToGridXY["경기도"]?["수원시팔달구"]?["화서1동"];
    if (coords != null) {
      forecastData = fetchForecast(
        serviceKey: "4TEeEbCQ7DrRqU1z1MlvSAIFG1Did9WbvUx8GJ6nquLWxEYz7%2BUqu2ToWCArhD4VXIiD3L4hrRHHEazI2I3pkA%3D%3D",
        nx: coords["x"]!,
        ny: coords["y"]!,
      );
    } else {
      forecastData = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("날씨 예보")),
      // futureBuilder
      body: FutureBuilder<List<Map<String, String>>>(
        // request 변수 담아서 비동기 처리
        future: forecastData,
        // api 호출중....ㄱ오류시 결과출력
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ 오류 발생: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //실제로 데이터가 비어있는 상태
            return const Center(child: Text("예보 데이터 없음"));
          }
          
          //api 데이터를 성공적으로 불러왔을때
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                title: Text("${item["label"]}: ${item["value"]}"),
                subtitle: Text("${item["fcstTime"]}시 예보"),

              );
            },
          );
        },
      ),
    );
  }
}
