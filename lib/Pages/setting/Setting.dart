import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl/Object/user.dart';
import 'package:btl/Pages/setting/changePassword.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<user>(context).sUsername;

    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 48,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(username.toString()),
                  )
                ],
              )),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.grey[200]),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tài khoản",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangePassword())),
                                  },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                width: double.infinity,
                                child: const Row(
                                  children: [
                                    Icon(Icons.settings),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text("Đổi mật khẩu"),
                                    ),
                                  ],
                                ),
                              )),
                          GestureDetector(
                            onTap: () => {
                              Provider.of<user>(context, listen: false)
                                  .setUsername("")
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              width: double.infinity,
                              child: const Row(
                                children: [
                                  Icon(Icons.flag_outlined),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Đăng xuất"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
