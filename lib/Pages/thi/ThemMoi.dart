import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();
  File? _image;

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }
  //
  // Future<void> _uploadImage() async {
  //   if (_image != null) {
  //     final ref = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().toIso8601String()}');
  //     await ref.putFile(_image!);
  //     return await ref.getDownloadURL();
  //   }
  //   return null;
  // }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // final imageUrl = await _uploadImage();

      await FirebaseFirestore.instance.collection('Product').add({
        'sMaHang': _codeController.text,
        'sTenHang': _nameController.text,
        'sMoTa': _descriptionController.text,
        'iDonGia': double.parse(_priceController.text),
        'iSoLuong': int.parse(_quantityController.text),
        'sGhiChu': _noteController.text,
        'sLinkImage': "https://firebasestorage.googleapis.com/v0/b/baitl-38912.appspot.com/o/Remove-bg.ai_1719759042797.png?alt=media&token=af8e1c03-f78f-4439-ace6-5c50e75197c4",
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thêm mới hàng hóa thành công!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm mới hàng hóa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: _image == null
              //       ? Container(
              //     height: 150,
              //     color: Colors.grey[200],
              //     child: Center(child: Text('Pick Image')),
              //   )
              //       : Image.file(_image!),
              // ),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Mã hàng'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập mã hàng' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên hàng'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên hàng' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập mô tả' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Đơn giá'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập đơn giá' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Số lượng'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập số lượng' : null,
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Ghi chú'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Thêm mới'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
