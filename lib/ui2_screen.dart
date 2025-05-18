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
              children: [Align(
  alignment: Alignment.topLeft,
  child: GestureDetector(
    onTap: () {

      //Navigator.pop(context); // 이전 화면으로 돌아가기
    
    },
    child: Icon(
      Icons.arrow_left, // 삼각형 느낌의 왼쪽 화살표
      size: 20 * scaleW,
      color: Colors.black87,
    ),
  ),
),
SizedBox(height: 4 * scaleH),

                // 상단 회색 상자 (장소 입력 안내)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 8 * scaleH, horizontal: 10 * scaleW),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(6 * scaleW),
                  ),
                  child: Text(
                    '장소를 입력하고 등록 버튼을 누르세요.',
                    style: TextStyle(
                      fontSize: 8 * scaleW,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 10 * scaleH),

                // 입력 필드 1
                _inputField('장소명', scaleW, scaleH),
                SizedBox(height: 6 * scaleH),

                // 입력 필드 2
                _inputField('주소', scaleW, scaleH),
                SizedBox(height: 6 * scaleH),

                // 입력 필드 3
                _inputField('위도', scaleW, scaleH),
                SizedBox(height: 6 * scaleH),

                // 입력 필드 4
                _inputField('경도', scaleW, scaleH),
                SizedBox(height: 14 * scaleH),

                // 등록 버튼
                Center(
                  child: Container(
                    width: 70 * scaleW,
                    height: 28 * scaleH,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBBBBBB),
                      borderRadius: BorderRadius.circular(6 * scaleW),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '등록',
                      style: TextStyle(
                        fontSize: 8 * scaleW,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
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
