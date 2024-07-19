import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart';
import 'package:btl/Pages/Dashboard/ThongTinDoUong.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _OderdouongState();
}

class _OderdouongState extends State<Test> {
  TextEditingController name = TextEditingController();
  TextEditingController detail = TextEditingController();
  TextEditingController price = TextEditingController();
  final keyform = GlobalKey<FormState>();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 30,
                  width: 60,
                  child: Center(
                    child: Text(
                      "Bàn 1",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        suffixIcon: Icon(Icons.search))),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 400,
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
                                      builder: (context) => Thongtindouong()));
                            },
                          ),
                          Positioned(
                            child: Container(
                                height: 60,
                                width: 370,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(10))),
                            top: 30,
                          ),
                          Positioned(
                            child: Container(
                              color: Colors.white,
                              height: 90,
                              width: 70,
                              child: Image.asset(
                                "assets/images/drink1.png",
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
                                    listDrink[index].sTenDoUong,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    listDrink[index].sThongTinChiTiet,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    listDrink[index].iGia.toString(),
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
                    itemCount: listDrink.length,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: keyform,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter name:",
                        label: Text("Name"),
                      ),
                      controller: name,
                      validator: (value) {
                        if (value == null) {
                          return "Không được để trống";
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter drink details:",
                        label: Text("Details"),
                      ),
                      controller: detail,
                      validator: (value) {
                        if (value == null) {
                          return "Không được để trống";
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter price:",
                        label: Text("Price"),
                      ),
                      controller: price,
                      validator: (value) {
                        if (value == null) {
                          return "Không được để trống";
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String data1 = name.text;
                        String data2 = detail.text;
                        int data3 = int.parse(price.text);
                        setState(() {
                          listDrink.add(drink(
                              sMaDoUong: "",
                              sTenDoUong: data1,
                              iGia: data3,
                              sThongTinChiTiet: data2,
                              sSize: "",
                              iDuong: 0,
                              iDa: 0,
                              sMaTopping: "",
                              sImg: ""));
                        });
                      },
                      child: Text("Add"),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
