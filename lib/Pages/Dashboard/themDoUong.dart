import 'package:btl/Pages/Dashboard/gioHang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final List<String> sizes = ['S', 'M', 'L'];
  final List<int> iceLevels = [0, 50, 100];
  final List<int> sugarLevels = [0, 50, 100];
  final List<String> toppings = ['TP1', 'TP2', 'TP3','Không'];

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
            Card(
              margin: EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Image.network(widget.detail_drink.sImg, width: 100,height: 100,),

                title: Text(
                  widget.detail_drink.sTenDoUong,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),

                ),

                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [

                      Text(
                        widget.detail_drink.iGia.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        "VND",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            Text(
              'Chọn Size:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...sizes.map((String size) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: RadioListTile<String>(
                  title: Text(size),
                  value: size,
                  groupValue: selectedSize,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSize = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 16.0),
            Text(
              'Chọn Đá:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...iceLevels.map((int iceLevel) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: RadioListTile<int>(
                  title: Text(iceLevelToString(iceLevel)),
                  value: iceLevel,
                  groupValue: selectedIceLevel,
                  onChanged: (int? value) {
                    setState(() {
                      selectedIceLevel = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 16.0),
            Text(
              'Chọn Đường:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...sugarLevels.map((int sugarLevel) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: RadioListTile<int>(
                  title: Text(sugarLevelToString(sugarLevel)),
                  value: sugarLevel,
                  groupValue: selectedSugarLevel,
                  onChanged: (int? value) {
                    setState(() {
                      selectedSugarLevel = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 16.0),
            Text(
              'Chọn Topping:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...toppings.map((String topping) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: RadioListTile<String>(
                  title: Text(topping),
                  value: topping,
                  groupValue: selectedTopping,
                  onChanged: (String? value) {
                    setState(() {
                      selectedTopping = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedSize != null &&
                      selectedIceLevel != null &&
                      selectedSugarLevel != null) {
                    // Create a new drink with the selected options
                    final newDrink = drink(
                      drinkId: widget.detail_drink.drinkId,
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

                    print("cccccc ${newDrink.drinkId}");

                    // Save to Firestore
                    Map<String, dynamic> data = {
                      "drinkId": newDrink.drinkId,
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => gioHang(
                          tenBan: widget.tenBan,
                        ),
                      ),
                          (route) => false, // Loại bỏ tất cả các route hiện có
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng chọn đầy đủ thông tin'),
                      ),
                    );
                  }
                },
                child: Text('Thêm vào giỏ hàng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
