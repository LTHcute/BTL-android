import 'package:btl/Object/drink.dart';
import 'package:btl/Object/table.dart';
import 'package:btl/Pages/OderDoUong.dart';
import 'package:btl/Pages/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  List<drink> listDrink=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(

            title: Text("DANH MỤC BÀN",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 20),),
            centerTitle: true,
          ),
         body: StreamBuilder<QuerySnapshot>(

           stream: FirebaseFirestore.instance.collection("Table").orderBy("sTenBan",descending: false).snapshots(),
           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return Center(child: CircularProgressIndicator());
             } else if (snapshot.hasError) {
               return Center(child: Text('Error: ${snapshot.error}'));
             } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
               return Center(child: Text('No data available'));
             }
             var documents = snapshot.data!.docs;

                 return Center(child: GridView.builder(
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 3,
                   childAspectRatio: 1
               ),
               itemCount: documents.length,
               itemBuilder: (context, index) {
                 return Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       GestureDetector(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => Oderdouong()));
                         },
                         child:  Container(child: Center(
                           child: Text(documents[index]["sTenBan"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15),),
                         ),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10),
                               color: statusColor(documents[index]["sTrangThai"])),
                           width: 100,
                           height: 100,
                         ),
                       )]);


               },
             ),);

           },
         ),

         bottomNavigationBar: BottomNavigationBar(
           backgroundColor: Colors.green,
           unselectedItemColor: Colors.black,
           selectedItemColor: Colors.white,
           items: [
             BottomNavigationBarItem(icon: Icon(Icons.star),
             label:"Trang chủ"),
             BottomNavigationBarItem(icon: Icon(Icons.list_alt),
             label: "Lịch sử"),
             BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted_outlined),
             label: "Cá nhân")
           ],
         ),


         );
  }

  statusColor(status) {
    switch(status)
        {
      case 'Trống':
       return Colors.grey;
        break;
      case "Đang sử dụng":
       return Colors.green;
        break;
      case "Đã đặt":
      return  Colors.orange;
        break;

    }
  }
}



void ShowDialog()
{
  AlertDialog(
    title: Text("Lựa chọn",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 17),),
  actions: [
    ElevatedButton(onPressed: (){}, child: Text("Đặt trước",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 15),),style: ButtonStyle(),)
  ],
  );
}


