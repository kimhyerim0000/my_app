// ✅ Smart Shoe Cabinet UI (모듈화 완료 + 상단 회색 박스 클래스 적용)
import 'package:flutter/material.dart';
import 'ui2_screen.dart'; // ✅ UI_2 화면 import
import 'ui3_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'ui4_screen.dart';
import 'xyTest.dart';
import 'address_to_gridxy_korea.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SmartUIApp());
}
// storage에서 이미지 가져오기
Future<String> getImageUrl(String imageName) async {
  final ref = FirebaseStorage.instance.ref().child('test/$imageName');
  final url = await ref.getDownloadURL();
  print('✅ 이미지 URL: $url');
  return url;
}
class SmartUIApp extends StatelessWidget {
  const SmartUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UI_1',
      debugShowCheckedModeBanner: false,
      home: UIScreen(),
    );
  }
}

class UIScreen extends StatefulWidget {

  const UIScreen({super.key});

  @override
  State<UIScreen> createState() => _UIScreenState();


}

class _UIScreenState extends State<UIScreen> {
  bool autoDry = false;
  bool heater = false;
  bool led = false;
  double tempValue = 25.0;
  double humidityValue = 55.0;
  String registeredAddress = '자주 가는 장소를 등록해주세요!'; // ✅ 초기 기본값 설정
  // List<String> registeredAddresses = ['', '', ''];

  @override
  void initState() {
    super.initState();
    loadSelectedAddressFromFirebase(); //registeredAddress값을 불러옴.
    loadCurrentTemperatureAndHumidity(); //아두이노가 기록한 온습도를 main에 표시함.
  }
  void loadSelectedAddressFromFirebase() async {
    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child("shoeCabinet/selectedAddress").get();

    if (snapshot.exists) {
      final selectedAddress = snapshot.value.toString(); // 데이터 변환
      setState(() {
        registeredAddress = selectedAddress;
      });
      print('✅ 불러온 주소: $selectedAddress');
    } else {
      print("⚠️ selectedAddress 값이 없음");
    }
  }
  void loadCurrentTemperatureAndHumidity() async {
    final dbRef = FirebaseDatabase.instance.ref();

    try {
      final tempSnap = await dbRef.child("current/TEMPERATURE").get();
      final humSnap = await dbRef.child("current/HUMIDITY").get();

      if (tempSnap.exists && humSnap.exists) {
        final double temp = double.tryParse(tempSnap.value.toString()) ?? 0.0;
        final double hum = double.tryParse(humSnap.value.toString()) ?? 0.0;

        setState(() {
          tempValue = temp;
          humidityValue = hum;
        });

        print("✅ 온도: $temp, 습도: $hum");
      } else {
        print("⚠️ current/TEMPERATURE 또는 HUMIDITY 값 없음");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleW = size.width / 200;
    final scaleH = size.height / 300;

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Center(
        child: Container(
          width: 200 * scaleW,
          height: 300 * scaleH,
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD),
            border: Border.all(color: const Color(0xFFBBBBBB)),
            borderRadius: BorderRadius.circular(12 * scaleW),
          ),
          child: Padding(
            padding: EdgeInsets.all(12 * scaleW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10 * scaleH),
                ImageWithControlsBox(
                  scaleW: scaleW,
                  scaleH: scaleH,
                  onSettingsChanged: (newTemp, newHumidity) {
                    setState(() {
                      tempValue = newTemp;
                      humidityValue = newHumidity;
                    });
                    // //데이터베이스에 저장
                    // saveTemperatureAndHumidity(newTemp, newHumidity);
                  },
                  onAddressSelected: (selectedAddress) {
                    setState(() {
                      registeredAddress = selectedAddress;
                    });
                  },
                  registeredAddresses: const ['', '', ''],
                  // // DB에 list변수 저장, 일반변수 저장. ,registeredAddresses
                  // registeredAddresses: registeredAddresses,
                ),

                SizedBox(height: 10 * scaleH),
                SensorBoxesRow(
                  temp: tempValue,
                  humidity: humidityValue,
                ),
                SizedBox(height: 5 * scaleH),
                Flexible( // 👈 여기에 적용
                  child:  WeatherAwareAddressSection(scaleW: scaleW, scaleH: scaleH ,address: registeredAddress, ),
                ),
                // SizedBox(height: 5 * scaleH),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UI4Screen()),
                    );
                  },
                  child: WeatherSummaryBox(scaleW: scaleW, scaleH: scaleH)
                  ,
                )

                // Flexible(
                //   child: BottomControlPanel(
                //     scaleW: scaleW,
                //     autoDry: autoDry,
                //     heater: heater,
                //     led: led,
                //     onToggle: (type, value) {
                //       setState(() {
                //         if (type == 'autoDry') autoDry = value;
                //         if (type == 'heater') heater = value;
                //         if (type == 'led') led = value;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageWithControlsBox extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  final void Function(double, double) onSettingsChanged;
  final void Function(String) onAddressSelected;
  final List<String> registeredAddresses;

  const ImageWithControlsBox({super.key, required this.scaleW, required this.scaleH,
    required this.onSettingsChanged,required this.onAddressSelected,required this.registeredAddresses,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6 * scaleW),
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(8 * scaleW),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70 * scaleW,
            height: 70 * scaleH,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(8 * scaleW),
            ),
            child: FutureBuilder<String>(
              future: getImageUrl('test.jpg'), // Firebase에 있는 이미지 이름
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error, color: Colors.red);
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8 * scaleW),
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      width: 70 * scaleW,
                      height: 70 * scaleH,
                    ),
                  );
                }
              },
            ),

          ),
          SizedBox(width: 10 * scaleW),
          Column(
            children: [
              // 아래에 해당 버튼이 정의됨
              SideButton(
                label: "자주 가는 장소 등록",
                scaleW: scaleW,
                scaleH: scaleH,
                addresses: registeredAddresses,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UI2Screen(),
                    ),
                  );
                  if (result != null && result is String) {
                    onAddressSelected(result);
                  }
                },
              ),

              SizedBox(height: 10 * scaleH),
              SideButton(
                label: "적정 온습도 설정관리",
                scaleW: scaleW,
                scaleH: scaleH,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UI3Screen()),
                  );

                  if (result != null && result is Map) {
                    onSettingsChanged(
                      result['temp'] ?? 25.0,
                      result['humidity'] ?? 55.0,
                    );
                  }
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}

class SideButton extends StatelessWidget {
  final String label;
  final double scaleW;
  final double scaleH;
  final VoidCallback? onTap;
  final List<String>? addresses;
  final void Function(String)? onAddressSelected;
  const SideButton({super.key, required this.label, required this.scaleW, required this.scaleH,this.onTap,this.addresses,this.onAddressSelected,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () async {
        if (label == "자주 가는 장소 등록") {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UI2Screen(),
            ),
          );

          if (result != null && result is String) {
            onAddressSelected?.call(result); // ✅ 전달
          }
        }
        if (label == "적정 온습도 설정관리") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UI3Screen()),
          );
        }
      },

      child: Container(
        width: 80 * scaleW,
        height: 30 * scaleH,
        decoration: BoxDecoration(
          color: const Color(0xFFBBBBBB),
          borderRadius: BorderRadius.circular(6 * scaleW),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 6 * scaleW, color: Colors.black87),
        ),
      ),
    );
  }
}


class SensorBoxesRow extends StatelessWidget {
  final double temp;
  final double humidity;

  const SensorBoxesRow({
    super.key,
    required this.temp,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleW = size.width / 200;
    final scaleH = size.height / 300;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _sensorBox("내부 온도\n\t\t\t ${temp.toInt()}도", scaleW, scaleH),
        _sensorBox("내부 습도\n\t\t\t  ${humidity.toInt()}%", scaleW, scaleH),
      ],
    );
  }

  Widget _sensorBox(String label, double scaleW, double scaleH) {
    return Container(
      width: 69 * scaleW,
      height: 41 * scaleH,
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        border: Border.all(color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(6 * scaleW),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 12 * scaleW, color: Colors.black87),
        ),
      ),
    );
  }
}


class AddressSection extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  final String address;
  final String weatherMessage;

  const AddressSection({super.key, required this.scaleW, required this.scaleH,required this.address,required this.weatherMessage,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('자주가는 장소', style: TextStyle(fontSize: 7 * scaleW, color: Colors.grey[800])),
        SizedBox(height: 3 * scaleH),
        AddressBox(scaleW: scaleW, scaleH: scaleH,address: address,),
        SizedBox(height: 3 * scaleH),
        Text(
          weatherMessage,
          style: TextStyle(fontSize: 5 * scaleW, color: Colors.black87),
          maxLines: 2,
        ),
      ],
    );
  }
}

class AddressBox extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  final String address;

  const AddressBox({super.key, required this.scaleW, required this.scaleH,required this.address,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180 * scaleW,
      height: 20 * scaleH,
      padding: EdgeInsets.all(4 * scaleW),
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(6 * scaleW),
      ),
      child: Text(
        address,
        style: TextStyle(fontSize: 6 * scaleW, color: Colors.black87),
      ),
    );
  }
}

class WeatherSummaryBox extends StatelessWidget {
  final double scaleW;
  final double scaleH;

  const WeatherSummaryBox({super.key, required this.scaleW, required this.scaleH});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170 * scaleW,              // ImageWithControlsBox 기준 가로 길이
      height: 70 * scaleH,            // 2배 높이
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(6 * scaleW),
      ),
      padding: EdgeInsets.all(6 * scaleW),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '날씨 예보',
            style: TextStyle(fontSize: 7 * scaleW, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6 * scaleH),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text("☀️", style: TextStyle(fontSize: 14)),
              Text("🌧", style: TextStyle(fontSize: 14)),
              Text("☁️", style: TextStyle(fontSize: 14)),
              Text("⛈", style: TextStyle(fontSize: 14)),
              Text("❄️", style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
class WeatherAwareAddressSection extends StatefulWidget {
  final double scaleW;
  final double scaleH;
  final String address;

  const WeatherAwareAddressSection({
    super.key,
    required this.scaleW,
    required this.scaleH,
    required this.address,
  });

  @override
  State<WeatherAwareAddressSection> createState() => _WeatherAwareAddressSectionState();
}

class _WeatherAwareAddressSectionState extends State<WeatherAwareAddressSection> {
  String weatherMessage = "☀️ 날씨 정보를 불러오는 중입니다...";

  @override
  void initState() {
    super.initState();
    loadWeatherMessage();
  }

  Future<void> loadWeatherMessage() async {
    try {
      // 👉 주소 → 좌표 변환 (예시: 종로구 청운효자동)
      final coords = addressToGridXY["서울특별시"]?["종로구"]?["청운효자동"];
      if (coords == null) {
        setState(() {
          weatherMessage = "⚠️ 주소 정보로 좌표를 찾을 수 없습니다.";
        });
        return;
      }

      final forecast = await fetchForecast(
        serviceKey: "4TEeEbCQ7DrRqU1z1MlvSAIFG1Did9WbvUx8GJ6nquLWxEYz7%2BUqu2ToWCArhD4VXIiD3L4hrRHHEazI2I3pkA%3D%3D",
        nx: coords['x']!,
        ny: coords['y']!,
      );

      if (forecast.isEmpty) {
        setState(() {
          weatherMessage = "📭 날씨 예보 데이터를 불러올 수 없습니다.";
        });
        return;
      }

      final msg = generateWeatherMessage(forecast);
      setState(() {
        weatherMessage = msg;
      });
    } catch (e) {
      setState(() {
        weatherMessage = "❌ 날씨 정보를 불러오는 중 오류가 발생했습니다.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddressSection(
      scaleW: widget.scaleW,
      scaleH: widget.scaleH,
      address: widget.address,
      weatherMessage: weatherMessage,
    );
  }
}



// class BottomControlPanel extends StatelessWidget {
//   final double scaleW;
//   final bool autoDry;
//   final bool heater;
//   final bool led;
//   final void Function(String, bool) onToggle;
//
//   const BottomControlPanel({
//     super.key,
//     required this.scaleW,
//     required this.autoDry,
//     required this.heater,
//     required this.led,
//     required this.onToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Column(
//         //   crossAxisAlignment: CrossAxisAlignment.start,
//         //   children: [
//         //     Icon(Icons.ac_unit, color: Colors.blue, size: 14 * scaleW),
//         //     Text('수', style: TextStyle(fontSize: 6 * scaleW)),
//         //     Text('최고 28°', style: TextStyle(fontSize: 6 * scaleW)),
//         //     Text('최저 14°', style: TextStyle(fontSize: 6 * scaleW)),
//         //   ],
//         // ),
//         WeatherSummaryBox(scaleW: scaleW),
//
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSwitch('자동 건조 기능', autoDry, (val) => onToggle('autoDry', val)),
//             _buildSwitch('히터 on/off', heater, (val) => onToggle('heater', val)),
//             _buildSwitch('LED on/off', led, (val) => onToggle('led', val)),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: TextStyle(fontSize: 6 * scaleW)),
//         Switch(value: value, onChanged: onChanged),
//       ],
//     );
//   }
// }
//

