import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl/Object/user.dart';
import 'package:btl/Pages/Dashboard/DangNhap.dart';
import 'package:btl/Pages/Dashboard/TrangChu.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<user>(context).sUsername;

    if (username == "") {
      return DangNhap();
    } else {
      return const TrangChu();
    }
  }
}
