import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart'; // Import mô hình Drink

class donThanhCong extends StatefulWidget {
  final int totalAmount;
  final String tenBan;
  final List<drink> orderedDrinks;

  const donThanhCong({
    Key? key,
    required this.totalAmount,
    required this.tenBan,
    required this.orderedDrinks,
  }) : super(key: key);

  @override
  _donThanhCongState createState() => _donThanhCongState();
}

class   _donThanhCongState extends State<donThanhCong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt Đơn Thành Công"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Đặt đồ uống thành công',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.tenBan,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tổng tiền: ${widget.totalAmount} VND',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Chi tiết đơn hàng:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.orderedDrinks.length,
                itemBuilder: (context, index) {
                  final drink = widget.orderedDrinks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Image.network(drink.sImg, width: 50),
                      title: Text(drink.sTenDoUong),
                      subtitle: Text(
                        'Size: ${drink.sSize}\nĐá: ${drink.iDa}%\nĐường: ${drink.iDuong}%\nGiá: ${drink.iGia} VND\nSL: ${drink.iSoLuong}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
