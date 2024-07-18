import 'package:cloud_firestore/cloud_firestore.dart';

class table {
  String sTenBan;
  String sTrangThai;

  table({required this.sTenBan, required this.sTrangThai});

  static table fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return table(
      sTenBan: snapshot['sTenBan'],
      sTrangThai: snapshot['sTrangThai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sTenBan": sTenBan,
      "sTrangThai": sTrangThai,
    };
  }
}
