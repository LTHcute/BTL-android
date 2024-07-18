import 'package:fluttertoast/fluttertoast.dart';
import 'package:btl/Object/user.dart';
import 'package:btl/Pages/TrangChu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DangNhap());
}

class DangNhap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DangNhap();
}

class _DangNhap extends State<DangNhap> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> checkAcc(String name) async {
    QuerySnapshot document = await firestore
        .collection("User")
        .where("sUsername", isEqualTo: name)
        .get();
    if (document.docs.isNotEmpty) {
      var pw = document.docs.first;
      if (pw["sPassword"] == password.text) {
        print("Done");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TrangChu()),
            (route) => false);
      } else {
        print("password wrong");
        Fluttertoast.showToast(msg: "Tài khoản không hợp lệ");
      }
    } else {
      print("Tài khoản không tồn tại");
      Fluttertoast.showToast(msg: "Tài khoản không hợp lệ");
    }
  }

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: ListView(
        children: [
          Center(
            child: Container(
              height: 200,
              width: 300,
              child: Image.asset("assets/images/logo.jpg"),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(0),
              child: Text(
                "Starbucks Coffee",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(50),
              child: Form(
                key: formkey,
                child: Column(children: [
                  Text(
                    "Đăng nhập",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                        hintText: "Nhập username", labelText: "Username"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nhập username";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Nhập password",
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(Icons.remove_red_eye),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nhập username";
                      }
                      if (value.length < 8) {
                        return "Password không đủ 8 kí tự";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (bool? value) {},
                      ),
                      Text("Lưu thông tin mật khẩu"),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          print("123");
                          if (formkey.currentState!.validate()) {
                            print(username.text);
                            checkAcc(username.text);
                          }
                        });
                      },
                      child: Text("Đăng nhập"))
                ]),
              )),
        ],
      ),
    );
  }
}
