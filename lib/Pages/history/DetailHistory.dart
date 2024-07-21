import 'dart:developer';

import 'package:btl/Object/BillDetail.dart';
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

    print("aaaaa ${billId}");

    Future<List<Map<String, dynamic>>> getDrinksByBillId(String billId) async {
      // Reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Step 1: Get the drinkIds from bill_drink collection by billId
      QuerySnapshot billDrinkSnapshot = await firestore
          .collection('Bill_Detail')
          .where('sMaHoaDon', isEqualTo: billId)
          .get();

      // Step 2: Extract BillDetail and Drink information
      List<BillDetail> billDetails = billDrinkSnapshot.docs.map((doc) {
        return BillDetail.fromFirestore(doc);
      }).toList();

      // Extract drinkIds from billDrinkSnapshot
      List<String> drinkIds = billDrinkSnapshot.docs.map((doc) {
        return doc['sMaDoUong'] as String;
      }).toList();


      // Step 2: Get the drinks from drink collection using drinkIds
      //
      // List<Drink> drinks = [];
      // for (String drinkId in drinkIds) {
      //   DocumentSnapshot drinkSnapshot =
      //       await firestore.collection('Drink').doc(drinkId).get();
      //   if (drinkSnapshot.exists) {
      //     drinks.add(Drink.fromFirestore(drinkSnapshot));
      //   }
      // }
      //
      // return drinks;

      List<Map<String, dynamic>> detailedBillDetails = [];
      for (BillDetail billDetail in billDetails) {
        DocumentSnapshot drinkSnapshot =
        await firestore.collection('Drink').doc(billDetail.sMaDoUong).get();
        if (drinkSnapshot.exists) {
          Drink drink = Drink.fromFirestore(drinkSnapshot);
          detailedBillDetails.add({
            'bill_detail': billDetail,
            'drink': drink,
          });
        }
      }

      return detailedBillDetails;
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
                "Bàn ${bill['sMaBan']}",
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
                  Text("Danh sách đồ uống", style: const TextStyle(fontSize: 20)),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: getDrinksByBillId(billId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Đơn hàng này không có đồ uống.'));
                      } else {
                        List<Map<String, dynamic>> drinks = snapshot.data!;
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                itemCount: drinks.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0), // Adjust the padding as needed
                                    child: ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                        child: Text(
                                          "(${drinks[index]['bill_detail'].iSoLuong}x) ${drinks[index]['drink'].sTenDoUong}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),),
                                        Text("${formatter.format(drinks[index]['drink'].iGia)} Đ")
                                      ],
                                    ),
                                    subtitle: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Row(children: [
                                        Flexible(
                                          child: Text(
                                            "Size: ${drinks[index]['bill_detail'].sSize}, Đường: ${drinks[index]['bill_detail'].iDuong}%, Đá: ${drinks[index]['bill_detail'].iDa}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                      ]),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ));
                                }));
                      }
                    },
                  ),

                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: const BorderRadius.all(
                    Radius.circular(12) //                 <--- border radius here
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        "Tổng cộng: ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Text(
                        "${formatter.format(bill['fThanhTien'])} Đ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ))
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
