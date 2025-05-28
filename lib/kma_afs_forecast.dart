import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: KmaAFSForecastView(),
  ));
}

class KmaAFSForecastView extends StatefulWidget {
  const KmaAFSForecastView({super.key});

  @override
  State<KmaAFSForecastView> createState() => _KmaAFSForecastViewState();
}

class _KmaAFSForecastViewState extends State<KmaAFSForecastView> {
  List<Map<String, String>> forecastList = [];

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  Future<void> fetchForecast() async {
    final url = Uri.parse(
      'https://apihub.kma.go.kr/api/typ01/url/fct_afs_dl.php'
          '?reg=11B10101&tmfc1=2013121106&tmfc2=2013121118&disp=0&help=1&authKey=ArDk5uWmThKw5Oblpv4SFg',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = await CharsetConverter.decode("euc-kr", response.bodyBytes);
        print('📦 응답 원본:\n$decoded');

        final lines = decoded
            .split('\n')
            .map((e) => e.trim())
            .where((line) => line.isNotEmpty && !line.startsWith('#'))
            .toList();

        List<Map<String, String>> parsed = [];

        for (final line in lines) {
          final parts = line.split(RegExp(r'\s+'));
          if (parts.length >= 17) {
            final tmFcRaw = parts[1].trim();
            final tmEfRaw = parts[2].trim();
            final ta = parts[13];
            final wf = parts[16];

            String monthDay = '';
            if (tmFcRaw.length == 12 && RegExp(r'^\d{12}\$').hasMatch(tmFcRaw)) {
              try {
                final date = DateFormat('yyyyMMddHHmm').parseStrict(tmFcRaw);
                monthDay = DateFormat('MMdd').format(date);
              } catch (e) {
                print('⚠️ TM_FC 파싱 실패: $tmFcRaw → $e');
              }
            }

            parsed.add({
              '날짜': monthDay,

              '기온': ta,
              '예보': wf.replaceAll(RegExp(r'^"|"$'), ''),
            });
          } else {
            print('❗ 조건 불충분: $line');
          }
        }

        setState(() {
          forecastList = parsed;
        });
      }
    } catch (e) {
      setState(() {
        forecastList = [
          {'날짜': '', '기온': '', '예보': e.toString()}
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("단기예보 요약")),
      body: forecastList.isEmpty
          ? const Center(child: Text('⛅ 예보 데이터가 없습니다'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: forecastList.length,
        itemBuilder: (context, index) {
          final item = forecastList[index];
          return ListTile(
            title: Text('${item['날짜']} : ${item['예보']}'),
            subtitle: Text('기온: ${item['기온']}℃'),
          );
        },
      ),
    );
  }
}