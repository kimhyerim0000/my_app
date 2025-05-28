import 'address_to_gridxy_korea.dart';

void main() {
  String si = "경기도";
  String gu = "수원시팔달구";
  String dong = "화서1동";

  final xy = addressToGridXY[si]?[gu]?[dong];
  if (xy != null) {
    print("x=${xy['x']}, y=${xy['y']}");
  } else {
    print("⚠️ 격자 좌표를 찾을 수 없습니다.");
  }
}