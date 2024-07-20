import 'package:btl/Pages/Dashboard/donThanhCong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart'; // Import mô hình Drink

class xacNhanDon extends StatefulWidget {
  final int totalAmount;
  final String tenBan;
  final List<drink> orderedDrinks;

  const xacNhanDon({
    Key? key,
    required this.totalAmount,
    required this.tenBan,
    required this.orderedDrinks,
  }) : super(key: key);

  @override
  _xacNhanDonState createState() => _xacNhanDonState();
}

class _xacNhanDonState extends State<xacNhanDon> {
  String _selectedPaymentMethod = 'Tiền mặt'; // Default payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác Nhận Đơn Hàng"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center the table number text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                widget.tenBan,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Text(
            '    Đồ uống đã đặt:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                      'Size: ${drink.sSize}\nĐá: ${drink.iDa}%\nĐường: ${drink
                          .iDuong}%\nTopping: ${drink.sMaTopping}\nGiá: ${drink
                          .iGia} VND\nSL: ${drink.iSoLuong}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.totalAmount} VND',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '    Phương thức thanh toán:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue!;
                });
              },
              items: <String>['Gửi hóa đơn SMS', 'Tiền mặt', 'Chuyển khoản']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true, // Expand the dropdown to full width
            ),
          ),
          SizedBox(height: 16.0),
          // Add some space between the payment method and the button
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  updateTable();
                  // Điều hướng đến trang donThanhCong
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            donThanhCong(
                                totalAmount: widget
                                    .totalAmount,
                                // Make sure cartDrinks is defined and populated
                                orderedDrinks: widget
                                    .orderedDrinks,
                                // Replace with you r actual total amount calculation
                                tenBan: widget.tenBan)),(route) => false,
                  );
                  // Handle the payment or order confirmation here
                  print('Selected Payment Method: $_selectedPaymentMethod');
                },
                child: Text('Xác nhận đơn hàng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  // Button color
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  // Button padding
                  textStyle: TextStyle(fontSize: 18), // Button text style
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateTable() async {
    print(widget.tenBan);
    QuerySnapshot document = await FirebaseFirestore.instance.collection(
        "Table").where("sTenBan",isEqualTo: widget.tenBan).get();
    if(document.docs.isNotEmpty)
      {
       DocumentReference docRef = document.docs.first.reference;
       await docRef.update({"sTrangThai":"Đang sử dụng"});
      }
  }}

