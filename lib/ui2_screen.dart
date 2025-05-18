import 'package:flutter/material.dart';

class UI2Screen extends StatefulWidget {
  const UI2Screen({super.key});

  @override
  State<UI2Screen> createState() => _UI2ScreenState();
}
class _UI2ScreenState extends State<UI2Screen> {
  final TextEditingController inputController = TextEditingController();
  String registeredAddress = '';

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
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_left,
                      size: 20 * scaleW,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 4 * scaleH),
                Text("자주 가는 장소 등록", style: TextStyle(color: Colors.black, fontSize:6*scaleW)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 24 * scaleH,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          border: Border.all(color: const Color(0xFFAAAAAA)),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8 * scaleW),
                        child: TextField(
                          controller: inputController, // ← 위에서 선언한 TextEditingController 사용
                          style: TextStyle(fontSize: 7 * scaleW),
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleW),
                    RegisterButton(
                      scaleW: scaleW,
                      scaleH: scaleH,
                      onTap: () {
                        setState(() {
                          registeredAddress = inputController.text;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10 * scaleH),
                InputFieldsColumn(
  scaleW: scaleW,
  scaleH: scaleH,
  addressText: registeredAddress, // 전달!
),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _inputField(String hint, double scaleW, double scaleH) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8 * scaleW),
  //     height: 24 * scaleH,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFE0E0E0),
  //       borderRadius: BorderRadius.circular(6 * scaleW),
  //       border: Border.all(color: const Color(0xFFAAAAAA)),
  //     ),
  //     child: Align(
  //       alignment: Alignment.centerLeft,
  //       child: Text(
  //         hint,
  //         style: TextStyle(
  //           fontSize: 7 * scaleW,
  //           color: Colors.black54,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class InputFieldsColumn extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  final String addressText;

  const InputFieldsColumn({
    super.key,
    required this.scaleW,
    required this.scaleH,
    required this.addressText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("주소1", style: TextStyle(color: Colors.black, fontSize: 4 * scaleW)),
        Container(
          height: 24 * scaleH,
          padding: EdgeInsets.symmetric(horizontal: 8 * scaleW),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            border: Border.all(color: const Color(0xFFAAAAAA)),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            addressText,
            style: TextStyle(fontSize: 7 * scaleW, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}


  Widget _labeledInputWithButton(String label, String hint, double scaleW, double scaleH) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(label, style: TextStyle(color: Colors.black, fontSize: 4 * scaleW)),
      SizedBox(width: 6 * scaleW),
      Expanded(
        child: Container(
          height: 24 * scaleH,
          padding: EdgeInsets.symmetric(horizontal: 8 * scaleW),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: const Color(0xFFAAAAAA)),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: TextStyle(fontSize: 7 * scaleW, color: Colors.black54),
          ),
        ),
      ),
      SizedBox(width: 1 * scaleW),
      Container(
        width: 15 * scaleW,
        height: 24 * scaleH,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black54),
        ),
        alignment: Alignment.center,
  child: Text(
    '선택',
    style: TextStyle(
      fontSize: 6 * scaleW,
      color: Colors.black,
    ),
  ),
      ),
    ],
  );
}

// 자주가는 장소 등록 '등록' 버튼
class RegisterButton extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  final VoidCallback onTap;

  const RegisterButton({
    super.key,
    required this.scaleW,
    required this.scaleH,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30 * scaleW,
        height: 24 * scaleH,
        decoration: BoxDecoration(
          color: const Color(0xFFBBBBBB),
          borderRadius: BorderRadius.circular(0),
        ),
        alignment: Alignment.center,
        child: Text(
          '등록',
          style: TextStyle(
            fontSize: 6 * scaleW,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
