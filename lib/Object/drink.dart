import 'package:cloud_firestore/cloud_firestore.dart';

class drink {
  String drinkId;
  String sMaDoUong;
  String sTenDoUong;
  int iGia;
  String sThongTinChiTiet;
  String sImg;
  late String sSize;
  late int iSoLuong; // Số lượng

  late int iDuong;
  late int iDa;
  late String sMaTopping;

  var fThanhTien;

  drink({
    required this.sMaDoUong,
    required this.sTenDoUong,
    required this.iGia,
    required this.sThongTinChiTiet,
    required this.sImg,
    this.sSize = "",
    this.iSoLuong = 0,
    this.iDuong = 0,
    this.iDa = 0,
    this.sMaTopping = "",
    this.fThanhTien = 0,
    this.drinkId = "",
  });
  static drink fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return drink(
        sMaDoUong: snapshot['sMaDoUong'],
        sTenDoUong: snapshot['sTenDoUong'],
        iGia: snapshot['iGia'],
        sThongTinChiTiet: snapshot['sThongTinChiTiet'],
        sImg: snapshot['sImg'],
        sSize: snapshot['sSize'],
        iSoLuong: snapshot['iSoLuong'],
        iDuong: snapshot['iDuong'],
        iDa: snapshot['iDa'],
        fThanhTien: snapshot['fThanhTien'],
        sMaTopping: snapshot['sMaTopping']);
  }

  Map<String, dynamic> toJson() {
    return {
      "sMaDoUong": sMaDoUong,
      "sTenDoUong": sTenDoUong,
      "iGia": iGia,
      "sThongTinChiTiet": sThongTinChiTiet,
      "sImg": sImg,
      "sSize": sSize,
      "iSoLuong": iSoLuong,
      "iDuong": iDuong,
      "iDa": iDa,
      "sMaTopping": sMaTopping,
      "fThanhTien": fThanhTien
    };
  }
}

class drink2 {
  String sMaDoUong;
  String sTenDoUong;
  int iGia;

  String sImg;

  drink2(
      {required this.sMaDoUong,
      required this.sTenDoUong,
      required this.iGia,
      required this.sImg});

  static drink2 fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return drink2(
        sMaDoUong: snapshot['sMaDoUong'],
        sTenDoUong: snapshot['sTenDoUong'],
        iGia: snapshot['iGia'],
        sImg: snapshot['sImg']);
  }

  Map<String, dynamic> toJson() {
    return {
      "sMaDoUong": sMaDoUong,
      "sTenDoUong": sTenDoUong,
      "iGia": iGia,
      "sImg": sImg
    };
  }
}

class drinkadd {
  late String sSize;
  late int iSoLuong; // Số lượng

  late int iDuong;
  late int iDa;
  late String sMaTopping;

  drinkadd(
      {required this.sSize,
      required this.iSoLuong,
      required this.iDuong,
      required this.iDa,
      required this.sMaTopping});

  static drinkadd fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return drinkadd(
        sSize: snapshot['sSize'],
        iSoLuong: snapshot['iSoLuong'],
        iDuong: snapshot['iDuong'],
        iDa: snapshot['iDa'],
        sMaTopping: snapshot['sMaTopping']);
  }

  Map<String, dynamic> toJson() {
    return {
      "sSize": sSize,
      "iSoLuong": iSoLuong,
      "iDuong": iDuong,
      "iDa": iDa,
      "sMaTopping": sMaTopping,
    };
  }
}
