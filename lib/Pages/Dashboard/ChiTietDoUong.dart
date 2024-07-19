import 'package:flutter/material.dart';


class Chitietdouong extends StatefulWidget {
  const Chitietdouong({super.key});

  @override
  State<Chitietdouong> createState() => _ChitietdouongState();
}

class _ChitietdouongState extends State<Chitietdouong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CHI TIẾT ĐỒ UỐNG"),
        centerTitle: true,
      ),
       body: Center(
         child: Column(
           children: [
             Container(child: Image.asset("name")),
             SizedBox(height: 20,),
             Text("Tên đồ uống"),
             SizedBox(height: 10,),
             Text("Chi tiết đồ uống"),
             SizedBox(height: 10,),
             Text("Giá"),
             ElevatedButton(onPressed: (){}, child: Text("Đặt đồ"))

           ],
         ),
       )
    );
  }
}
