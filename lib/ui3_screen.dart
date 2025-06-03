import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class UI3Screen extends StatefulWidget {
  const UI3Screen({super.key});

  @override
  State<UI3Screen> createState() => _UI3ScreenState();
}

class _UI3ScreenState extends State<UI3Screen> {
  double tempValue = 25.0;
  double humidityValue = 55.0;
  bool autoEnabled = false;
  bool ledEnabled = false;
  bool fanEnabled = false;

  // 라디오버튼의 데이터베이스 상태 적용
  @override
  void initState() {
    super.initState();
    loadSettingsFromFirebase(); // ✅ 설정값 Firebase에서 불러오기
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleW = size.width / 200;
    final scaleH = size.height / 300;


    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Center(
        child: Container(
          width: 200 * scaleW,
          height: 300 * scaleH,
          padding: EdgeInsets.all(8 * scaleW),
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(12 * scaleW),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, {
                      // 'temp': tempValue,
                      // 'humidity': humidityValue,
                    });
                  },
                  child: Icon(
                    Icons.arrow_left,
                    size: 20 * scaleW,
                    color: Colors.black87,
                  ),
                ),
              ),
              Positioned(
                top: 30 * scaleH,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _settingBox(
                            title: "적정 온도 설정",
                            value: tempValue,
                            onIncrease: () {
                              setState(() {
                                tempValue += 1;
                                saveTemperatureAndHumidity(tempValue, humidityValue);
                              });
                            },
                            onDecrease: () {
                              setState(() {
                                tempValue -= 1;
                                saveTemperatureAndHumidity(tempValue, humidityValue);
                              });
                            },
                            scaleW: scaleW,
                            scaleH: scaleH,
                          ),
                          _settingBox(
                            title: "적정 습도 설정",
                            value: humidityValue,
                            onIncrease: () {
                              setState(() {
                                humidityValue += 1;
                                saveTemperatureAndHumidity(tempValue, humidityValue);
                              });
                            },
                            onDecrease: () {
                              setState(() {
                                humidityValue -= 1;
                                saveTemperatureAndHumidity(tempValue, humidityValue);
                              });
                            },
                            scaleW: scaleW,
                            scaleH: scaleH,
                          ),
                        ],
                      ),
                      //auto
                      SizedBox(height: 30 * scaleH),
                      Text(
                        "AUTO",
                        style: TextStyle(
                          fontSize: 5 * scaleW,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4 * scaleH),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("off", style: TextStyle(fontSize: 4 * scaleW)),
                          SizedBox(width: 4 * scaleW),
                          Switch(
                            value: autoEnabled,
                            onChanged: (val) {
                              setState(() {
                                autoEnabled = val;
                                saveSetting("AUTO", val);
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.grey,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          SizedBox(width: 4 * scaleW),
                          Text("on", style: TextStyle(fontSize: 4 * scaleW)),
                        ],
                      ),
                      //led
                      SizedBox(height: 30 * scaleH),
                      Text(
                        "LED",
                        style: TextStyle(
                          fontSize: 5 * scaleW,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4 * scaleH),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("off", style: TextStyle(fontSize: 4 * scaleW)),
                          SizedBox(width: 4 * scaleW),
                          Switch(
                            value: ledEnabled,
                            onChanged: (val) {
                              setState(() {
                                ledEnabled = val;
                                saveSetting("LED", val);
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.grey,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          SizedBox(width: 4 * scaleW),
                          Text("on", style: TextStyle(fontSize: 4 * scaleW)),
                        ],
                      ),
                      //fan
                      SizedBox(height: 30 * scaleH),
                      Text(
                        "FAN",
                        style: TextStyle(
                          fontSize: 5 * scaleW,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4 * scaleH),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("off", style: TextStyle(fontSize: 4 * scaleW)),
                          SizedBox(width: 4 * scaleW),
                          Switch(
                            value: fanEnabled,
                            onChanged: (val) {
                              setState(() {
                                fanEnabled = val;
                                saveSetting("FAN", val);
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.grey,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          SizedBox(width: 4 * scaleW),
                          Text("on", style: TextStyle(fontSize: 4 * scaleW)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // setting/$key에 저장됨.
  void saveSetting(String key, bool value) async {
    final dbRef = FirebaseDatabase.instance.ref();
    try {
      await dbRef.child("settings/$key").set(value ? 1 : 0);
      print('✅ settings/$key = ${value ? 1 : 0} 저장됨');
    } catch (e) {
      print('❌ settings/$key 저장 실패: $e');
    }
  }

  // 설정한 버튼값 저장하기
  void loadSettingsFromFirebase() async {
    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child("settings").get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        autoEnabled = (data['AUTO'] == 1);
        ledEnabled = (data['LED'] == 1);
        fanEnabled = (data['FAN'] == 1);
      });
      print("✅ Firebase에서 설정값 불러오기 성공: $data");
    } else {
      print("⚠️ Firebase 연결됨, 하지만 데이터 없음");
    }
  }
  //온습도 값 저장
  void saveTemperatureAndHumidity(double temp, double humidity) async {
    final dbRef = FirebaseDatabase.instance.ref();
    await dbRef.child("settings").update({
      'TEMPERATURE': temp,
      'HUMIDITY': humidity,
    });
    print('✅ 온습도 저장됨: settings/TEMPERATURE=$temp, settings/HUMIDITY=$humidity');
  }

  Widget _settingBox({
    required String title,
    required double value,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
    required double scaleW,
    required double scaleH,
  }) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 5 * scaleW, color: Colors.black)),
        SizedBox(height: 4 * scaleH),
        Container(
          width: 70 * scaleW,
          height: 40 * scaleH,
          padding: EdgeInsets.symmetric(horizontal: 4 * scaleW),
          decoration: BoxDecoration(
            color: const Color(0xFFD0CCCC),
            borderRadius: BorderRadius.circular(6 * scaleW),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrease,
                iconSize: 14 * scaleW,
                padding: EdgeInsets.zero,
              ),
              Text("${value.toInt()}",
                  style: TextStyle(fontSize: 5 * scaleW)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onIncrease,
                iconSize: 14 * scaleW,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
