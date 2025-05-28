// ✅ Smart Shoe Cabinet UI (모듈화 완료 + 상단 회색 박스 클래스 적용)
import 'package:flutter/material.dart';
import 'ui2_screen.dart'; // ✅ UI_2 화면 import
import 'ui3_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'ui4_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SmartUIApp());
}
Future<String> getImageUrl(String imageName) async {
  final ref = FirebaseStorage.instance.ref().child('test/$imageName');
  final url = await ref.getDownloadURL();
  print('✅ 이미지 URL: $url');
  return url;
}
void saveTemperatureAndHumidity(double temp, double humidity) async {
  final dbRef = FirebaseDatabase.instance.ref();

  await dbRef.child("shoeCabinet/settings").set({
    'temperature': temp,
    'humidity': humidity,
  });
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
  List<String> registeredAddresses = ['', '', ''];
  

  void loadAddressesFromFirebase() async {
    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child("shoeCabinet/addresses").get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        registeredAddresses = [
          data['0'] ?? '',
          data['1'] ?? '',
          data['2'] ?? '',
        ];
      });
      print('✅ 주소 불러오기 성공: $registeredAddresses');
    } else {
      print('ℹ️ 저장된 주소가 없습니다.');
    }
  }
  @override
  void initState() {
    super.initState();
    loadAddressesFromFirebase(); // ✅ 앱 시작 시 불러옴
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
                    //데이터베이스에 저장
                    saveTemperatureAndHumidity(newTemp, newHumidity);
                  },
                  onAddressSelected: (selectedAddress) {
                    setState(() {
                      registeredAddress = selectedAddress;
                    });
                  },
                  // DB에 list변수 저장, 일반변수 저장. ,registeredAddresses
                  registeredAddresses: registeredAddresses,
                ),

                SizedBox(height: 10 * scaleH),
                SensorBoxesRow(
                  temp: tempValue,
                  humidity: humidityValue,
                ),
                SizedBox(height: 5 * scaleH),
                Flexible( // 👈 여기에 적용
                  child: AddressSection(scaleW: scaleW, scaleH: scaleH,address: registeredAddress, ),
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

  // "shoeCabinet/addresses" 위치에 registeredAddresses 리스트 값 저장
  void saveAddressesToFirebase(List<String> addresses) async {
    final dbRef = FirebaseDatabase.instance.ref();
    await dbRef.child("shoeCabinet/addresses").set({
      '0': addresses[0],
      '1': addresses[1],
      '2': addresses[2],
    });
    print('✅ 주소 3개 Firebase에 저장 완료');
  }
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
                      builder: (_) => UI2Screen(
                        addresses: registeredAddresses, // ✅ 주소 리스트 넘기기
                      ),
                    ),
                  );
                  if (result != null && result is String) {
                    onAddressSelected(result);
                    saveAddressesToFirebase(registeredAddresses);
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
  const SideButton({super.key, required this.label, required this.scaleW, required this.scaleH,this.onTap,this.addresses,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        if (label == "자주 가는 장소 등록") {
          Navigator.push(
            context,
              MaterialPageRoute(
                builder: (_) => UI2Screen(
                  addresses: addresses ?? ['', '', ''], //
                ),
              )
          );
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

  const AddressSection({super.key, required this.scaleW, required this.scaleH,required this.address,});

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
          '내일 눈 소식 있어요! 미끄럼 조심하고 따뜻한 신발 준비해주세요❄️👟',
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

