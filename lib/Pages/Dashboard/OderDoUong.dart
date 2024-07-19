import 'package:btl/Object/drink.dart';
import 'package:btl/Pages/Dashboard/ChiTietDoUong.dart';
import 'package:btl/Pages/Dashboard/ThongTinDoUong.dart';
import 'package:btl/Pages/Dashboard/themDoUong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Oderdouong extends StatefulWidget {
  final String tenBan;

  Oderdouong({super.key, required this.tenBan});

  @override
  State<Oderdouong> createState() => _OderdouongState();
}

class _OderdouongState extends State<Oderdouong> {
  TextEditingController searchDrink = TextEditingController();

  @override
  void initState() {
    getDrink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = null;
    if (searchDrink.text == null) {
      setState(() {
        data = FirebaseFirestore.instance.collection("Drink").snapshots();
      });
    } else {
      setState(() {
        data = FirebaseFirestore.instance
            .collection("Drink")
            .where("sTenDoUong",
                isGreaterThan: searchDrink.text.toCapitalized())
            .where("sTenDoUong",
                isLessThan: searchDrink.text + "\uf8ff".toCapitalized())
            .orderBy("sTenDoUong", descending: false)
            .snapshots();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "CHỌN ĐỒ UỐNG",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              height: 30,
              width: 60,
              child: Center(
                child: Text(
                  widget.tenBan,
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
                onChanged: (value) {
                  setState(() {
                    data = FirebaseFirestore.instance
                        .collection("Drink")
                        .where("sTenDoUong", isGreaterThan: searchDrink.text)
                        .orderBy("sTenDoUong", descending: false)
                        .snapshots();
                  });
                },
                controller: searchDrink,
                decoration: InputDecoration(
                    hintText: "Search your drinks",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    suffixIcon: IconButton(
                        onPressed: () {
                          print("1");
                          //getSearch(searchDrink.text);

                          //  showSearch(context: context, delegate: CustomSearch());
                        },
                        icon: Icon(Icons.search)))),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: StreamBuilder(
              stream: data,
              //FirebaseFirestore.instance.collection("Drink").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null) {
                  return Center(
                    child: Text('Không có dữ liệu'),
                  );
                }
                var document = snapshot.data!.docs;

                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Thongtindouong()));
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
                                      String img = document[index]["sImg"];
                                      String name_drink =
                                          document[index]["sTenDoUong"];
                                      String detail =
                                          document[index]["sThongTinChiTiet"];
                                      int price = document[index]["iGia"];

                                      drink new_drink = drink(
                                          sMaDoUong: "",
                                          sTenDoUong: name_drink,
                                          iGia: price,
                                          sThongTinChiTiet: detail,
                                          sImg: img,
                                          sSize: '',
                                          iSoLuong: 0,
                                          iDa: 0,
                                          iDuong: 0,
                                          sMaTopping: '',
                                          fThanhTien: '');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  new Chitietdouong(
                                                    detail_drink: new_drink,
                                                  )));
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
                                    child: GestureDetector(
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
                                              document[index]["iGia"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                        height: 50,
                                        width: 260,
                                      ),
                                      onTap: () {},
                                    ),
                                    top: 40,
                                    left: 100,
                                    bottom: 10,
                                  ),
                                  Positioned(
                                    child: Container(
                                      height: 40,
                                      width: 50,
                                      child: GestureDetector(
                                        onTap: () {
                                          String img = document[index]["sImg"];
                                          String name_drink =
                                              document[index]["sTenDoUong"];
                                          String detail = document[index]
                                              ["sThongTinChiTiet"];
                                          int price = document[index]["iGia"];

                                          drink new_drink = drink(
                                              sMaDoUong: "",
                                              sTenDoUong: name_drink,
                                              iGia: price,
                                              sThongTinChiTiet: detail,
                                              sImg: img,
                                              sSize: '',
                                              iSoLuong: 0,
                                              iDa: 0,
                                              iDuong: 0,
                                              sMaTopping: '',
                                              fThanhTien: '');

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      new themDoUong(
                                                        detail_drink: new_drink,
                                                        tenBan: widget.tenBan,
                                                      )));
                                        },
                                        child: Icon(Icons.add_shopping_cart),
                                      ),
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

  search(String value) {}
}

Future<List<Map<String, dynamic>>> getSearch(String searchDrink) async {
  print("2");

  final drinkCollection = FirebaseFirestore.instance;
  QuerySnapshot firestore = await drinkCollection
      .collection("Drink")
      .where("sTenDoUong", isEqualTo: searchDrink)
      .get();

  return firestore.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

Future getDrink() async {
  QuerySnapshot drinkCollection =
      await FirebaseFirestore.instance.collection("Drink").get();

  List<drink> listDrink = [];
  if (drinkCollection.docs.isNotEmpty) {
    int count = 0;
    drinkCollection.docs.forEach((value) {
      count = count + 1;
      drink _drink = new drink(
          sMaDoUong: value["sMaDoUong"],
          sTenDoUong: value["sTenDoUong"],
          iGia: value["iGia"],
          sThongTinChiTiet: value["sThongTinChiTiet"],
          sImg: '',
          sSize: '',
          iSoLuong: value["iSoLuong"],
          iDuong: value["iDuong"],
          iDa: value["iDa"],
          sMaTopping: value["sMaTopping"],
          fThanhTien: '');
      listDrink.add(_drink);
    });
    print("count:" + count.toString());
  }
}

Future getDrinkFilter(String filters) async {
  QuerySnapshot drinkCollection = await FirebaseFirestore.instance
      .collection("Drink")
      .where("sTenDoUong", isGreaterThan: filters)
      .orderBy("sTenDoUong", descending: false)
      .get();

  List<drink> listDrink = [];
  if (drinkCollection.docs.isNotEmpty) {
    int count = 0;
    drinkCollection.docs.forEach((value) {
      count = count + 1;
      drink _drink = new drink(
          sMaDoUong: value["sMaDoUong"],
          sTenDoUong: value["sTenDoUong"],
          iGia: value["iGia"],
          sThongTinChiTiet: value["sThongTinChiTiet"],
          sImg: value["sImg"],
          sSize: '',
          iSoLuong: value["iSoLuong"],
          iDuong: value["iDuong"],
          iDa: value["iDa"],
          sMaTopping: value["sMaTopping"],
          fThanhTien: '');
      listDrink.add(_drink);
    });
    print("count:" + count.toString());
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
