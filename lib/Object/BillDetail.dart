import 'package:cloud_firestore/cloud_firestore.dart';

class BillDetail {
  final String sMaDoUong;
  final String sMaHoaDon;
  final String sMaTopping;
  final String sSize;
  final int iSoLuong;
  final int iDuong;
  final int iDa;


  BillDetail({
    required this.sMaDoUong,
    required this.sMaHoaDon,
    required this.sMaTopping,
    required this.sSize,
    required this.iSoLuong,
    required this.iDuong,
    required this.iDa,
  });

  factory BillDetail.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BillDetail(
      sMaDoUong: data['sMaDoUong'],
      sMaHoaDon: data['sMaHoaDon'],
      sMaTopping: data['sMaTopping'],
      sSize: data['sSize'],
      iSoLuong: data['iSoLuong'],
      iDuong: data['iDuong'],
      iDa: data['iDa']
    );
  }
}