import 'package:btl/Pages/gioHang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart';

class themDoUong extends StatefulWidget {
  final drink detail_drink;
  final String tenBan;

  themDoUong({Key? key, required this.detail_drink, required this.tenBan})
      : super(key: key);

  @override
  State<themDoUong> createState() => _themDoUongState();
}

class _themDoUongState extends State<themDoUong> {
  String? selectedSize;
  int? selectedIceLevel;
  int? selectedSugarLevel;
  String? selectedTopping;

  final List<String> sizes = ['Nhỏ', 'Vừa', 'Lớn'];
  final List<int> iceLevels = [0, 50, 100];
  final List<int> sugarLevels = [0, 50, 100];
  final List<String> toppings = ['Topping 1', 'Topping 2', 'Topping 3'];

  String iceLevelToString(int level) => '${level}%';

  String sugarLevelToString(int level) => '${level}%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "THÊM ĐỒ UỐNG",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Image.network(widget.detail_drink.sImg, width: 100)),
            SizedBox(height: 20),
            Text(
              widget.detail_drink.sTenDoUong,
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            SizedBox(height: 10),
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Size Selection
            Text('Chọn Size:'),
            ...sizes.map((String size) {
              return RadioListTile<String>(
                title: Text(size),
                value: size,
                groupValue: selectedSize,
                onChanged: (String? value) {
                  setState(() {
                    selectedSize = value;
                  });
                },
              );
            }).toList(),

            // Ice Level Selection
            Text('Chọn Đá:'),
            ...iceLevels.map((int iceLevel) {
              return RadioListTile<int>(
                title: Text(iceLevelToString(iceLevel)),
                value: iceLevel,
                groupValue: selectedIceLevel,
                onChanged: (int? value) {
                  setState(() {
                    selectedIceLevel = value;
                  });
                },
              );
            }).toList(),

            // Sugar Level Selection
            Text('Chọn Đường:'),
            ...sugarLevels.map((int sugarLevel) {
              return RadioListTile<int>(
                title: Text(sugarLevelToString(sugarLevel)),
                value: sugarLevel,
                groupValue: selectedSugarLevel,
                onChanged: (int? value) {
                  setState(() {
                    selectedSugarLevel = value;
                  });
                },
              );
            }).toList(),

            // Toppings Selection
            Text('Chọn Topping:'),
            ...toppings.map((String topping) {
              return RadioListTile<String>(
                title: Text(topping),
                value: topping,
                groupValue: selectedTopping,
                onChanged: (String? value) {
                  setState(() {
                    selectedTopping = value;
                  });
                },
              );
            }).toList(),

            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedSize != null &&
                        selectedIceLevel != null &&
                        selectedSugarLevel != null) {
                      // Create a new drink with the selected options
                      final newDrink = drink(
                        sMaDoUong: '',
                        sThongTinChiTiet: '',
                        sSize: selectedSize!,
                        iDa: selectedIceLevel!,
                        iDuong: selectedSugarLevel!,
                        sMaTopping: selectedTopping ?? '',
                        iSoLuong: 1,
                        sImg: widget.detail_drink.sImg,
                        sTenDoUong: widget.detail_drink.sTenDoUong,
                        iGia: widget.detail_drink.iGia,
                        fThanhTien: '',
                      );

                      // Save to Firestore
                      Map<String, dynamic> data = {
                        "sImg": newDrink.sImg,
                        "sTenDoUong": newDrink.sTenDoUong,
                        "iGia": newDrink.iGia,
                        "sMaTopping": newDrink.sMaTopping,
                        "iDa": newDrink.iDa,
                        "iDuong": newDrink.iDuong,
                        "sSize": newDrink.sSize,
                        "iSoLuong": newDrink.iSoLuong,
                        "sBan": widget.tenBan,
                        "fThanhTien": newDrink.fThanhTien,
                      };
                      final add = await FirebaseFirestore.instance
                          .collection("OrderTam")
                          .add(data);

                      // Optionally reset selections
                      setState(() {
                        selectedSize = null;
                        selectedIceLevel = null;
                        selectedSugarLevel = null;
                        selectedTopping = null;
                      });

                      // Navigate to GioHang with the updated cart
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => gioHang(
                            tenBan: widget.tenBan,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Vui lòng chọn đầy đủ thông tin')),
                      );
                    }
                  },
                  child: Text('Thêm vào giỏ hàng'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
