import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl/Object/user.dart';
import 'package:btl/Pages/Dashboard/TrangChu.dart';
import 'package:btl/service/UserService.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // input
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController reNewPassword = TextEditingController();

  // state
  bool isShowPassword = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<user>(context).sUsername;
    UserService userService = UserService();

    void showSnackBar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    log('aaaaaa' + username);

    Future<void> checkAcc() async {
      try {
        QuerySnapshot document = await firestore
            .collection("User")
            .where("sUsername", isEqualTo: username.toString())
            .get();

        if (document.docs.isNotEmpty) {
          if (document.docs[0]['sPassword'].toString() == oldPassword.text) {
            Map<String, dynamic> updateInfo = {
              "sPassword": newPassword.text,
            };
            await userService
                .updatePassword(document.docs[0].id, updateInfo)
                .then((value) {
              showSnackBar(context, "Cập nhật mật khẩu thành công!");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TrangChu()),
              );
            });
          } else {
            showSnackBar(context, "Mật khẩu cũ không chính xác!");
          }
        } else {
          print("Tài khoản không tồn tại");
        }
      } catch (e) {
        log('loi ' + e.toString());
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
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
              child: const Text(
                "Starbucks Coffee",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 0, 0),
            child: Row(
              children: [
                Text(
                  "Thay đổi mật khẩu",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.green[500]),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: Form(
                key: formkey,
                child: Column(children: [
                  TextFormField(
                    controller: oldPassword,
                    obscureText: !isShowPassword,
                    decoration: const InputDecoration(
                        hintText: "Nhập mật khẩu cũ", labelText: "Mật khẩu cũ"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập mật khẩu cũ";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: newPassword,
                    obscureText: !isShowPassword,
                    decoration: const InputDecoration(
                        hintText: "Nhập mật khẩu mới",
                        labelText: "Mật khẩu mới"),
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
                  TextFormField(
                    controller: reNewPassword,
                    obscureText: !isShowPassword,
                    decoration: const InputDecoration(
                        hintText: "Nhập lại mật khẩu mới",
                        labelText: "Xác nhận mật khẩu mới"),
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isShowPassword,
                          onChanged: (bool? value) {
                            setState(() {
                              isShowPassword = value!;
                            });
                          },
                        ),
                        const Text("Hiển thị mật khẩu"),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (formkey.currentState!.validate()) {
                              if (newPassword.text == reNewPassword.text) {
                                checkAcc();
                              } else {
                                showSnackBar(
                                    context, "Mật khẩu mới không trùng lặp!");
                              }
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16)),
                        child: const Text("Thay đổi mật khẩu",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}
