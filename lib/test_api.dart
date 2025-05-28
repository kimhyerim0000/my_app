import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TestAPIPage(),
  ));
}

class TestAPIPage extends StatefulWidget {
  const TestAPIPage({super.key});

  @override
  State<TestAPIPage> createState() => _TestAPIPageState();
}

class _TestAPIPageState extends State<TestAPIPage> {
  String _result = '⏳ 기상청 데이터를 불러오는 중...';

  @override
  void initState() {
    super.initState();
    fetchKMAData();
  }

  Future<void> fetchKMAData() async {
    final url = Uri.parse(
      'https://apihub.kma.go.kr/api/typ01/url/fct_shrt_reg.php?tmfc=0&authKey=ArDk5uWmThKw5Oblpv4SFg',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // ✅ euc-kr 인코딩을 UTF-8로 변환
        final decoded = await CharsetConverter.decode("euc-kr", response.bodyBytes);
        setState(() {
          _result = decoded;
        });
      } else {
        setState(() {
          _result = '❌ 요청 실패: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = '⚠️ 예외 발생: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('test_api.dart - 기상청 응답 확인')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          _result,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
