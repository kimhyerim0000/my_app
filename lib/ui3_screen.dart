import 'package:flutter/material.dart';

class UI3Screen extends StatefulWidget {
  const UI3Screen({super.key});

  @override
  State<UI3Screen> createState() => _UI3ScreenState();
}

class _UI3ScreenState extends State<UI3Screen> {
  double tempValue = 25.0;
  double humidityValue = 55.0;
  bool pushEnabled = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleW = size.width / 200;
    final scaleH = size.height / 300;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0), // ✅ 회색 배경
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
              // 뒤로가기 버튼
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_left,
                    size: 20 * scaleW,
                    color: Colors.black87,
                  ),
                ),
              ),

              // 내용
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
                            scaleW,
                            scaleH,
                            title: "적정 온도 설정",
                            value: "${tempValue.toInt()}°C",
                            onEdit: () {
                              setState(() {
                                tempValue += 1;
                              });
                            },
                          ),
                          _settingBox(
                            scaleW,
                            scaleH,
                            title: "적정 습도 설정",
                            value: "${humidityValue.toInt()}%",
                            onEdit: () {
                              setState(() {
                                humidityValue += 1;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30 * scaleH),
                      Text(
                        "푸시 알림",
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
                            value: pushEnabled,
                            onChanged: (val) {
                              setState(() {
                                pushEnabled = val;
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

  Widget _settingBox(double scaleW, double scaleH,
      {required String title,
        required String value,
        required VoidCallback onEdit}) {
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
              Text(value, style: TextStyle(fontSize: 5 * scaleW)),
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 6 * scaleW),
                ),
                child: Text("수정",
                    style: TextStyle(
                        color: Colors.black, fontSize: 4 * scaleW)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
