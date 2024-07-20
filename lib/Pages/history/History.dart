import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:btl/Pages/history/DetailHistory.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern();
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "LỊCH SỬ HOÁ ĐƠN",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Bill")
              .orderBy("dThoiGianLap", descending: true) //thêm 1 dòng này này là để sort theo dThoiGianLap
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
                Timestamp t = documentSnapshot['dThoiGianLap'] as Timestamp;
                DateTime date = t.toDate();

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
                          title: Text(
                            "${documentSnapshot['sMaBan']} | Tổng: ${formatter.format(documentSnapshot['fThanhTien'])} Đ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Row(children: [
                              const Text(
                                "Chi tiết hoá đơn",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                  " - ${documentSnapshot['iSoLuong'].toString()} đồ uống"),
                            ]),
                          ),
                          trailing: Text('${date.day}/${date.month}/${date.year}'),
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
