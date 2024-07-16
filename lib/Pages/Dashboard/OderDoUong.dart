import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart';
import 'package:btl/Pages/Dashboard/ChiTietDoUong.dart';
import 'package:btl/Pages/Dashboard/ThongTinDoUong.dart';

class Oderdouong extends StatefulWidget {
  const Oderdouong({super.key});

  @override
  State<Oderdouong> createState() => _OderdouongState();
}

class _OderdouongState extends State<Oderdouong> {
  // final drinkCollection = FirebaseFirestore.instance.collection("")
  List<drink> listDrink = [
    drink(
        sMaDoUong: "DU01",
        sTenDoUong: "Trà sữa hồng đào",
        iGia: 50000,
        sThongTinChiTiet: "Đào từ Hàn Quốc",
        sSize: "S",
        iDuong: 70,
        iDa: 50,
        sMaTopping: "",
        sImg: ""),
    drink(
        sMaDoUong: "DU01",
        sTenDoUong: "Trà vải hạt nhài",
        iGia: 60000,
        sThongTinChiTiet: "Vải tươi",
        sSize: "S",
        iDuong: 70,
        iDa: 50,
        sMaTopping: "",
        sImg: ""),
    drink(
        sMaDoUong: "DU01",
        sTenDoUong: "Trà vải hạt nhài",
        iGia: 60000,
        sThongTinChiTiet: "Vải tươi",
        sSize: "S",
        iDuong: 70,
        iDa: 50,
        sMaTopping: "",
        sImg: ""),
    drink(
        sMaDoUong: "DU01",
        sTenDoUong: "Trà vải hạt nhài",
        iGia: 60000,
        sThongTinChiTiet: "Vải tươi",
        sSize: "S",
        iDuong: 70,
        iDa: 50,
        sMaTopping: "",
        sImg: ""),
    drink(
        sMaDoUong: "DU01",
        sTenDoUong: "Trà vải hạt nhài",
        iGia: 60000,
        sThongTinChiTiet: "Vải tươi",
        sSize: "S",
        iDuong: 70,
        iDa: 50,
        sMaTopping: "",
        sImg: "")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CHỌN ĐỒ UỐNG",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 30,
              width: 60,
              child: Center(
                child: Text(
                  "Bàn 1",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
                decoration: InputDecoration(
                    hintText: "Search your drinks",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: Icon(Icons.search)))),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Drink").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                var document = snapshot.data!.docs;
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chitietdouong()));
                      },
                      child: Container(
                        height: 570,
                        child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 20,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      color: Colors.white,
                                      height: 100,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Thongtindouong()));
                                    },
                                  ),
                                  Positioned(
                                    child: Container(
                                        height: 60,
                                        width: 370,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    top: 30,
                                  ),
                                  Positioned(
                                    child: Container(
                                      color: Colors.white,
                                      height: 90,
                                      width: 70,
                                      child: Image.network(
                                        document[index]["sImg"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    left: 15,
                                    bottom: 15,
                                  ),
                                  Positioned(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            document[index]["sTenDoUong"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            document[index]["sMaDoUong"],
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            document[index]["iGia"].toString(),
                                            style: TextStyle(fontSize: 10),
                                          )
                                        ],
                                      ),
                                      height: 50,
                                      width: 260,
                                    ),
                                    top: 40,
                                    left: 100,
                                    bottom: 10,
                                  ),
                                  Positioned(
                                    child: Container(
                                      child: Icon(Icons.add_shopping_cart),
                                      height: 40,
                                      width: 50,
                                    ),
                                    top: 40,
                                    left: 300,
                                    bottom: 20,
                                  ),
                                ],
                              );
                            },
                            itemCount: document.length),
                      ),
                    ));
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: Size(200, 50),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Text(
                  "Đặt đồ",
                  style: TextStyle(),
                ),
                SizedBox(
                  width: 10,
                ),
                Stack(
                  children: [
                    Container(
                      child: Icon(
                        Icons.shopping_cart,
                      ),
                      height: 40,
                      width: 40,
                    ),
                    Positioned(
                      child: Text("0"),
                      left: 25,
                      bottom: 25,
                    )
                  ],
                )
              ],
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
