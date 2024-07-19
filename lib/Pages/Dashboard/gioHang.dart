import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart';
import 'package:btl/Pages/Dashboard/xacNhanDon.dart'; // Import trang Xác Nhận Đơn

class gioHang extends StatefulWidget {
  final String tenBan;
  const gioHang({super.key, required this.tenBan});

  @override
  State<gioHang> createState() => _GioHangState();
}

class _GioHangState extends State<gioHang> {
  List<drink> cartDrinks = [];

  // Hàm xóa món đồ khỏi Firestore
  Future<void> _deleteItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("OrderTam")
          .doc(docId)
          .delete();
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Lỗi khi xóa món đồ: $e");
    }
  }

  // Hàm cập nhật số lượng món đồ
  Future<void> _updateQuantity(String docId, int newQuantity) async {
    try {
      if (newQuantity > 0) {
        await FirebaseFirestore.instance
            .collection("OrderTam")
            .doc(docId)
            .update({
          'iSoLuong': newQuantity,
        });
      } else {
        // Nếu số lượng bằng 0, xóa món đồ
        await _deleteItem(docId);
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Lỗi khi cập nhật số lượng: $e");
    }
  }

  // Tính tổng tiền
  int _calculateTotalAmount() {
    int total = 0;
    for (var item in cartDrinks) {
      total += item.iGia * item.iSoLuong;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Giỏ Hàng",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("OrderTam")
            .where("sBan", isEqualTo: widget.tenBan)
            .snapshots(),
        builder: (context, snapshot) {
          cartDrinks = [];
          if (snapshot.hasData) {
            snapshot.data?.docs.forEach((value) {
              drink dr = drink(
                  sMaDoUong: value.id,
                  sTenDoUong: value["sTenDoUong"],
                  iGia: value["iGia"],
                  sThongTinChiTiet: '',
                  sImg: value["sImg"],
                  sSize: value["sSize"],
                  iSoLuong: value["iSoLuong"],
                  iDuong: value["iDuong"],
                  iDa: value["iDa"],
                  sMaTopping: value["sMaTopping"],
                  fThanhTien: '');
              cartDrinks.add(dr);
            });
          }

          int totalAmount = _calculateTotalAmount();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = cartDrinks[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(drink.sImg, width: 50),
                        title: Text(drink.sTenDoUong),
                        subtitle: Text(
                            'Size: ${drink.sSize}\nĐá: ${drink.iDa}%\nĐường: ${drink.iDuong}%\nTopping: ${drink.sMaTopping}\nGiá: ${drink.iGia * drink.iSoLuong} VND'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  if (drink.iSoLuong > 1) {
                                    // Decrease quantity
                                    _updateQuantity(
                                        drink.sMaDoUong, drink.iSoLuong - 1);
                                  } else {
                                    // Quantity is 1, so remove item
                                    _updateQuantity(drink.sMaDoUong, 0);
                                  }
                                });
                              },
                            ),
                            Text(' ${drink.iSoLuong}'),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  // Increase quantity
                                  _updateQuantity(
                                      drink.sMaDoUong, drink.iSoLuong + 1);
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.pink),
                              onPressed: () => _deleteItem(drink.sMaDoUong),
                            ),
                          ],
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
                      'Tổng tiền: ${_calculateTotalAmount()} VND',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => xacNhanDon(
                              orderedDrinks:
                                  cartDrinks, // Make sure cartDrinks is defined and populated
                              totalAmount:
                                  _calculateTotalAmount(), // Replace with your actual total amount calculation
                              tenBan: widget.tenBan,
                            ),
                          ),
                        );
                      },
                      child: Text('Thanh toán'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
