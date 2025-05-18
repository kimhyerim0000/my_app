import 'package:flutter/material.dart';

class UI2Screen extends StatefulWidget {
  const UI2Screen({super.key});

  @override
  State<UI2Screen> createState() => _UI2ScreenState();
}

class _UI2ScreenState extends State<UI2Screen> {
  final TextEditingController inputController = TextEditingController();
  List<String> registeredAddresses = ['', '', '']; // 주소 1~3 저장용

  void registerAddress() {
    String input = inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      // 비어있는 첫 번째 슬롯에 등록
      for (int i = 0; i < registeredAddresses.length; i++) {
        if (registeredAddresses[i].isEmpty) {
          registeredAddresses[i] = input;
          break;
        }
      }
      inputController.clear(); // 입력창 비우기
    });
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
                          controller: inputController,
                          style: TextStyle(fontSize: 7 * scaleW),
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleW),
                    RegisterButton(
                      scaleW: scaleW,
                      scaleH: scaleH,
                      onTap: registerAddress,
                    ),
                  ],
                ),
                SizedBox(height: 10 * scaleH),
                InputFieldsColumn(
                  scaleW: scaleW,
                  scaleH: scaleH,
                  hints: registeredAddresses,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 주소 1~3 표시용
class InputFieldsColumn extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  final List<String> hints;

  const InputFieldsColumn({
    super.key,
    required this.scaleW,
    required this.scaleH,
    required this.hints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6 * scaleW),
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labeledInputWithButton('주소1', hints[0].isEmpty ? '주소 1' : hints[0], scaleW, scaleH),
          SizedBox(height: 6 * scaleH),
          _labeledInputWithButton('주소2', hints[1].isEmpty ? '주소 2' : hints[1], scaleW, scaleH),
          SizedBox(height: 6 * scaleH),
          _labeledInputWithButton('주소3', hints[2].isEmpty ? '주소 3' : hints[2], scaleW, scaleH),
        ],
      ),
    );
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
}

// 등록 버튼
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
