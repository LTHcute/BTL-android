import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:btl/Object/DrinkTest.dart';

class DetailHistory extends StatelessWidget {
  const DetailHistory({super.key});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern();
    final bill = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

    Timestamp t = bill['dThoiGianLap'] as Timestamp;
    DateTime date = t.toDate();
    String billId = bill.id;

    Future<List<Drink>> getDrinksByBillId(String billId) async {
      // Reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Step 1: Get the drinkIds from bill_drink collection by billId
      QuerySnapshot billDrinkSnapshot = await firestore
          .collection('Bill_Drink')
          .where('billId', isEqualTo: billId)
          .get();

      // Extract drinkIds from billDrinkSnapshot
      List<String> drinkIds = billDrinkSnapshot.docs.map((doc) {
        return doc['drinkId'] as String;
      }).toList();

      // Step 2: Get the drinks from drink collection using drinkIds
      List<Drink> drinks = [];
      for (String drinkId in drinkIds) {
        DocumentSnapshot drinkSnapshot =
            await firestore.collection('Drink').doc(drinkId).get();
        if (drinkSnapshot.exists) {
          drinks.add(Drink.fromFirestore(drinkSnapshot));
        }
      }

      return drinks;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết hoá đơn"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.green[700],
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${date.hour}:${date.minute}:${date.second}'),
                      Text('${date.day}/${date.month}/${date.year}'),
                    ],
                  ),
                )),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey, width: 1),
                    bottom: BorderSide(color: Colors.grey, width: 1)),
              ),
              child: Text(
                "Bàn ${bill['sMaBan']} | Tổng: ${formatter.format(bill['fThanhTien'])} Đ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                children: [
                  Text("Danh sách đồ uống"),
                  FutureBuilder<List<Drink>>(
                    future: getDrinksByBillId(billId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No drinks found for this bill.'));
                      } else {
                        List<Drink> drinks = snapshot.data!;
                        return SizedBox(
                            height: 100, // Adjust this as per your requirement
                            child: ListView.builder(
                                itemCount: drinks.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      "Ten ${drinks[index].sTenDoUong} | Tổng: ${formatter.format(drinks[index].iGia)} Đ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Row(children: [
                                        const Text(
                                          "Mo ta",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            " - ${drinks[index].sThongTinChiTiet}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  );
                                }));
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
