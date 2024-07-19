import 'package:btl/Object/drink.dart';
import 'package:flutter/material.dart';

class Chitietdouong extends StatefulWidget {
  final drink detail_drink;

  Chitietdouong({super.key, required this.detail_drink});

  @override
  State<Chitietdouong> createState() => _ChitietdouongState();
}

class _ChitietdouongState extends State<Chitietdouong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CHI TIẾT ĐỒ UỐNG",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              child: Image.network(
            widget.detail_drink.sImg,
            width: 200,
          )),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.detail_drink.sTenDoUong,
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.detail_drink.sThongTinChiTiet,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  widget.detail_drink.iGia.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
                Text(
                  " VND",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )
              ],
            ),
          ),
          Stack(
            children: [
              Positioned(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Đặt đồ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(200, 50),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
