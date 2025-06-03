// import 'package:firebase_database/firebase_database.dart';
//
// String? si;
// String? gu;
// String? dong;
//
// Future<void> loadAddressFromFirebase() async {
//   final dbRef = FirebaseDatabase.instance.ref();
//   final snapshot = await dbRef.child('shoeCabinet/selectedAddress').get();
//
//   if (snapshot.exists) {
//     final address = snapshot.value.toString().trim();
//     final parts = address.split(' ');
//
//     if (parts.length >= 3) {
//       si = parts[0];
//       gu = parts[1];
//       dong = parts.sublist(2).join(' '); // "청운효자동", "화곡제2동" 등 처리
//       print('✅ 주소 분해됨: $si / $gu / $dong');
//     } else {
//       print("⚠️ 주소 형식이 잘못되었습니다: $address");
//     }
//   } else {
//     print("⚠️ Firebase에서 주소를 찾을 수 없습니다.");
//   }
// }
