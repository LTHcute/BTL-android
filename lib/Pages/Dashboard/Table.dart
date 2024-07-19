import 'package:btl/Object/drink.dart';
import 'package:btl/Pages/Dashboard/OderDoUong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableList extends StatefulWidget {
  const TableList({super.key});

  @override
  State<TableList> createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  List<drink> listDrink = [];

  statusColor(status) {
    switch (status) {
      case 'Trống':
        return Colors.grey;
        break;
      case "Đang sử dụng":
        return Colors.green;
        break;
      case "Đã đặt":
        return Colors.orange;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "DANH MỤC BÀN",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Table")
              .orderBy("sTenBan", descending: false)
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

            return Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (documents[index]["sTrangThai"] == "Trống") {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          "Lựa chọn",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17),
                                        ),
                                      ),
                                      actions: [
                                        Center(
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    print("Nhi ơi:" +
                                                        documents[index]
                                                            ["sTenBan"]);
                                                    final ft = FirebaseFirestore
                                                        .instance
                                                        .collection("Table")
                                                        .doc(documents[index]
                                                            .id);
                                                    print(ft);
                                                    ft.update({
                                                      "sTrangThai": "Đã đặt"
                                                    }).then((_) {
                                                      print(
                                                          "Update successful");
                                                    }).catchError((error) {
                                                      print(
                                                          "Update failed: $error");
                                                    });
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Text(
                                                  "Đặt trước",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.orange),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all<Size>(
                                                                Size(200, 40))),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  String tenBan =
                                                      documents[index]
                                                          ["sTenBan"];
                                                  print(tenBan);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              new Oderdouong(
                                                                  tenBan:
                                                                      tenBan)));
                                                },
                                                child: Text(
                                                  "Đặt đồ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.grey),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all<Size>(
                                                                Size(200, 40))),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            }
                            if (documents[index]["sTrangThai"] == "Đã đặt") {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          "Lựa chọn",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17),
                                        ),
                                      ),
                                      actions: [
                                        Center(
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    print("Nhi ơi:" +
                                                        documents[index]
                                                            ["sTenBan"]);
                                                    final ft = FirebaseFirestore
                                                        .instance
                                                        .collection("Table")
                                                        .doc(documents[index]
                                                            .id);
                                                    print(ft);
                                                    ft.update({
                                                      "sTrangThai": "Trống"
                                                    }).then((_) {
                                                      print(
                                                          "Update successful");
                                                    }).catchError((error) {
                                                      print(
                                                          "Update failed: $error");
                                                    });
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Text(
                                                  "Hủy đặt",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.orange),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all<Size>(
                                                                Size(200, 40))),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  String tenBan =
                                                      documents[index]
                                                          ["sTenBan"];
                                                  print(tenBan);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              new Oderdouong(
                                                                  tenBan:
                                                                      tenBan)));
                                                },
                                                child: Text(
                                                  "Đặt đồ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.grey),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all<Size>(
                                                                Size(200, 40))),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                documents[index]["sTenBan"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: statusColor(
                                    documents[index]["sTrangThai"])),
                            width: 100,
                            height: 100,
                          ),
                        )
                      ]);
                },
              ),
            );
          },
        ));
  }
}
