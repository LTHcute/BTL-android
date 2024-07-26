import 'package:btl/Pages/thi/ThemMoi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:btl/Pages/history/DetailHistory.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern();

    void _navigateToThemMoiHangHoa() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddProductScreen(),
        ),
      );
    }

    Future<void> _showDeleteConfirmDialog(BuildContext context, String productId) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xóa hàng hóa'),
            content: Text('Bạn có chắc muốn xóa hàng hóa này không?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('Product').doc(productId).delete();
                  Navigator.of(context).pop();
                },
                child: Text('Xóa'),
              ),
            ],
          );
        },
      );
    }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quản lý Hàng hóa",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _navigateToThemMoiHangHoa,
            ),
          ],
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Product")
              .orderBy("sMaHang", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }
            var documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = documents[index];
                // Timestamp t = documentSnapshot['dThoiGianLap'] as Timestamp;
                // DateTime date = t.toDate();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            color: Colors.white,
                            height: 90,
                            width: 70,
                            child: Image.network(
                              documentSnapshot["sLinkImage"],
                            fit: BoxFit.fill,
                          )),
                          title: Text(
                            "${documentSnapshot['sMaHang']} | ${documentSnapshot['sTenHang']} | ${formatter.format(documentSnapshot['iDonGia'])} Đ | SL: ${documentSnapshot['iSoLuong'].toString()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(
                                "Mô tả: ${documentSnapshot['sMoTa']}"
                              ),
                              Text(
                                  "Ghi chú: ${documentSnapshot['sGhiChu']}"),
                            ]),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmDialog(context, documentSnapshot.id),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailHistory(),
                                settings: RouteSettings(
                                  arguments: documentSnapshot,
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
