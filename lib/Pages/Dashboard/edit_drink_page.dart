import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDrinkPage extends StatefulWidget {
  final String drinkId;
  final String tenDoUong;
  final int gia;
  final int soLuong;
  final String size;
  final int da;
  final int duong;
  final String topping;

  const EditDrinkPage({
    Key? key,
    required this.drinkId,
    required this.tenDoUong,
    required this.gia,
    required this.soLuong,
    required this.size,
    required this.da,
    required this.duong,
    required this.topping,
  }) : super(key: key);

  @override
  _EditDrinkPageState createState() => _EditDrinkPageState();
}

class _EditDrinkPageState extends State<EditDrinkPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _sizeController;
  late TextEditingController _daController;
  late TextEditingController _duongController;
  late TextEditingController _toppingController;
  late int _soLuong;

  @override
  void initState() {
    super.initState();
    _sizeController = TextEditingController(text: widget.size);
    _daController = TextEditingController(text: widget.da.toString());
    _duongController = TextEditingController(text: widget.duong.toString());
    _toppingController = TextEditingController(text: widget.topping);
    _soLuong = widget.soLuong;
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _daController.dispose();
    _duongController.dispose();
    _toppingController.dispose();
    super.dispose();
  }

  Future<void> _updateDrink() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance
            .collection("OrderTam")
            .doc(widget.drinkId)
            .update({
          'sSize': _sizeController.text,
          'iDa': int.parse(_daController.text),
          'iDuong': int.parse(_duongController.text),
          'sMaTopping': _toppingController.text,
          'iSoLuong': _soLuong,
        });

        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        print("Error updating drink: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh Sửa Đồ Uống'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Size'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter size';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _daController,
                decoration: InputDecoration(labelText: 'Ice (%)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ice percentage';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _duongController,
                decoration: InputDecoration(labelText: 'Sugar (%)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sugar percentage';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _toppingController,
                decoration: InputDecoration(labelText: 'Topping'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter topping';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateDrink,
                child: Text('Update Drink'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
