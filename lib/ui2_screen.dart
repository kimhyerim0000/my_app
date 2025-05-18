import 'package:flutter/material.dart';

class UI2Screen extends StatelessWidget {
  const UI2Screen({super.key});

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
                    Expanded(child: _inputField('주소 입력', scaleW, scaleH)),
                    SizedBox(width: 8 * scaleW),
                    RegisterButton(scaleW: scaleW, scaleH: scaleH),
                  ],
                ),
                SizedBox(height: 10 * scaleH),
                InputFieldsColumn(scaleW: scaleW, scaleH: scaleH),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hint, double scaleW, double scaleH) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scaleW),
      height: 24 * scaleH,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(6 * scaleW),
        border: Border.all(color: const Color(0xFFAAAAAA)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          hint,
          style: TextStyle(
            fontSize: 7 * scaleW,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class InputFieldsColumn extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  const InputFieldsColumn({super.key, required this.scaleW, required this.scaleH});

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
      Text("주소1", style: TextStyle(color: Colors.black, fontSize:4*scaleW)),              
      _inputField('주소 1'),
      SizedBox(height: 6 * scaleH),
      Text("주소1", style: TextStyle(color: Colors.black, fontSize:4*scaleW)),
      _inputField('주소 2'),
      SizedBox(height: 6 * scaleH),
      Text("주소1", style: TextStyle(color: Colors.black, fontSize:4*scaleW)),
      _inputField('주소 3'),
    ],
  ),
);

  }

  Widget _inputField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scaleW),
      height: 24 * scaleH,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: const Color(0xFFAAAAAA)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          hint,
          style: TextStyle(
            fontSize: 7 * scaleW,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  final double scaleW;
  final double scaleH;
  const RegisterButton({super.key, required this.scaleW, required this.scaleH});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30 * scaleW,
      height: 24 * scaleH,
      decoration: BoxDecoration(
        color: const Color(0xFFBBBBBB),
        borderRadius: BorderRadius.circular(6 * scaleW),
      ),
      alignment: Alignment.center,
      child: Text(
        '등록',
        style: TextStyle(
          fontSize: 6 * scaleW,
          color: Colors.black,
        ),
      ),
    );
  }
}