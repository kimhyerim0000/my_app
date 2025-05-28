import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

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
        final decoded = await CharsetConverter.decode(
            "euc-kr", response.bodyBytes);
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
            final sky = parts[15];
            final prep = parts[16];
            final ta = parts[13];
            final st = parts[14];

            if (!['DB01', 'DB02', 'DB03', 'DB04'].contains(sky)) continue;
            if (!['1', '2', '3', '4', '0'].contains(prep)) continue;

            parsed.add({
              '하늘상태': sky,
              '강수유무': prep,
              '강수확률': st,
              '기온': ta,
              '강수코드': prep,
            });
          }
        }

        setState(() {
          forecastList = parsed;
        });
      }
    } catch (e) {
      setState(() {
        forecastList = [
          {'하늘상태': '에러', '강수유무': '', '강수확률': '', '기온': '', '강수코드': ''}
        ];
      });
    }
  }

  IconData getWeatherIcon(String sky) {
    switch (sky) {
      case 'DB01':
        return Icons.wb_sunny;
      case 'DB02':
        return Icons.wb_cloudy;
      case 'DB03':
        return Icons.cloud;
      case 'DB04':
        return Icons.cloud_queue;
      default:
        return Icons.help_outline;
    }
  }

  String getSkyText(String sky) {
    switch (sky) {
      case 'DB01':
        return '맑음';
      case 'DB02':
        return '구름조금';
      case 'DB03':
        return '구름많음';
      case 'DB04':
        return '흐림';
      default:
        return '미확인';
    }
  }

  String getPrecipText(String prep) {
    switch (prep) {
      case '1':
        return '비';
      case '2':
        return '비/눈';
      case '3':
        return '눈';
      case '4':
        return '눈/비';
      case '0':
        return '없음';
      default:
        return '';
    }
  }

  bool hasPrecip(String prep) => ['1', '2', '3', '4'].contains(prep);

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
          final sky = item['하늘상태'] ?? '';
          final prep = item['강수유무'] ?? '';
          final st = item['강수확률'] ?? '';
          final ta = item['기온'] ?? '';
          final code = item['강수코드'] ?? '';
          return ListTile(
            leading: Icon(getWeatherIcon(sky)),
            title: Text(getSkyText(sky)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('강수유무: ${getPrecipText(prep)}'),
                if (hasPrecip(prep)) Text('강수확률: $st%'),
                Text('기온: $ta℃'),
                if (hasPrecip(prep)) Text('강수코드: $code'),
              ],
            ),
          );
        },
      ),
    );
  }
}