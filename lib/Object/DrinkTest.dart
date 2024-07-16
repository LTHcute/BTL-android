import 'package:cloud_firestore/cloud_firestore.dart';

class Drink {
  String sMaDoUong;
  String sTenDoUong;
  int iGia;
  String sThongTinChiTiet;
  String sImg;
  Drink(
      {required this.sMaDoUong,
      required this.sTenDoUong,
      required this.iGia,
      required this.sThongTinChiTiet,
      required this.sImg});

  factory Drink.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Drink(
      sMaDoUong: data['sMaDoUong'],
      sTenDoUong: data['sTenDoUong'],
      iGia: data['iGia'],
      sThongTinChiTiet: data['sThongTinChiTiet'],
      sImg: data['sImg'],
    );
  }
}
