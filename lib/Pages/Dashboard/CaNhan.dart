import 'package:flutter/material.dart';
class CaNhan extends StatefulWidget {
  const CaNhan({super.key});

  @override
  State<CaNhan> createState() => _CaNhanState();
}

class _CaNhanState extends State<CaNhan> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Container(
            color: Colors.green,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

            ),
            child: Icon(Icons.person),

          ),
          title: Text("Username"),
        ),

      ),
    );
  }
}
