import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:btl/Object/drink.dart';
import 'package:btl/Pages/Dashboard/OderDoUong.dart';
import 'package:btl/Pages/Dashboard/Table.dart';
import 'package:btl/Pages/history/History.dart';
import 'package:btl/Pages/setting/Setting.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TableList(),
    History(),
    Setting()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<drink> listDrink = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Lịch sử"),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_outlined), label: "Cá nhân")
        ],
      ),
    );
  }

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
}

void ShowDialog() {
  AlertDialog(
    title: Text(
      "Lựa chọn",
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
    ),
    actions: [
      ElevatedButton(
        onPressed: () {},
        child: Text(
          "Đặt trước",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
        ),
        style: ButtonStyle(),
      )
    ],
  );
}
