import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future updatePassword(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .update(updateInfo);
  }
}
