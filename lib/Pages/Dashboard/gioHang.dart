import 'package:btl/Object/user.dart';
import 'package:btl/Pages/Dashboard/TrangChu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart';
import 'package:btl/Pages/Dashboard/xacNhanDon.dart';
import 'package:provider/provider.dart';

import 'OderDoUong.dart';
import 'edit_drink_page.dart'; // Import trang Xác Nhận Đơn

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

  int _calculateTotalQuantity() {
    int total = 0;
    for (var item in cartDrinks) {
      total += item.iSoLuong;
    }
    return total;
  }

  void _navigateToOrderDoUong() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Oderdouong(
          tenBan: widget.tenBan,
        ),
      ),
    );
  }

  // Method to clear all items from the cart
  Future<void> _deleteAllItems() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("OrderTam")
          .where("sBan", isEqualTo: widget.tenBan)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        cartDrinks.clear(); // Clear local list
      });
    } catch (e) {
      print("Lỗi khi xóa tất cả món đồ: $e");
    }
  }

  // Method to show confirmation dialog
  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa Tất Cả Món Đồ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa tất cả món đồ trong giỏ hàng?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Không'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Có'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TrangChu()), (route) => false,);
              //  Navigator.of(context).pop();
                // Close the dialog
                _deleteAllItems(); // Call method to delete all items
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void addBill() async {
      Map<String, dynamic> data = {
        "dThoiGianLap": Timestamp.now(),
        "sMaBan": widget.tenBan,
        "iSoLuong": _calculateTotalQuantity(),
        "sUsername": "",
        "fThanhTien": _calculateTotalAmount(),
      };
      try {
        DocumentReference docRef =
        await FirebaseFirestore.instance.collection("Bill").add(data);

        cartDrinks.forEach((drink) async {
          Map<String, dynamic> detailBillData = {
            "sMaHoaDon": docRef.id,
            "sMaDoUong": drink.drinkId,
            "sMaTopping": drink.sMaTopping,
            "sSize": drink.sSize,
            "iSoLuong": drink.iSoLuong,
            "iDuong": drink.iDuong,
            "iDa": drink.iDa,
          };
          await FirebaseFirestore.instance
              .collection("Bill_Detail")
              .add(detailBillData);
        });

        print("Document added with ID: ${docRef.id}");
      } catch (e) {
        print("Error adding document: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Giỏ Hàng",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToOrderDoUong,
          ),
        ],
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
                  drinkId: value["drinkId"],
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
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = cartDrinks[index];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Drink Information
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  // Drink Image
                                  Image.network(
                                    drink.sImg,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 8),
                                  // Drink Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          drink.sTenDoUong,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Size: ${drink.sSize}',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                        Text(
                                          'Đá: ${drink.iDa}%',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                        Text(
                                          'Đường: ${drink.iDuong}%',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                        Text(
                                          'Topping: ${drink.sMaTopping}',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Giá: ${drink.iGia * drink.iSoLuong} VND',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Action Controls (Edit, Delete, Quantity)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Quantity Controls
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          if (drink.iSoLuong > 1) {
                                            _updateQuantity(drink.sMaDoUong, drink.iSoLuong - 1);
                                          } else {
                                            _updateQuantity(drink.sMaDoUong, 0);
                                          }
                                        });
                                      },
                                    ),
                                    Text('${drink.iSoLuong}', style: TextStyle(fontSize: 14)),
                                    IconButton(
                                      icon: Icon(Icons.add, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          _updateQuantity(drink.sMaDoUong, drink.iSoLuong + 1);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Edit and Delete Buttons
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.orange),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditDrinkPage(
                                              drinkId: drink.sMaDoUong,
                                              tenDoUong: drink.sTenDoUong,
                                              gia: drink.iGia,
                                              soLuong: drink.iSoLuong,
                                              size: drink.sSize,
                                              da: drink.iDa,
                                              duong: drink.iDuong,
                                              topping: drink.sMaTopping,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.pink),
                                      onPressed: () => _deleteItem(drink.sMaDoUong),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );



                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _showDeleteConfirmationDialog, // Call the confirmation dialog
                  child: Text('Xóa Tất Cả'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Change button color if needed
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
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
                        addBill();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => xacNhanDon(
                              orderedDrinks: cartDrinks,
                              totalAmount: _calculateTotalAmount(),
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