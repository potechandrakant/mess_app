import 'package:cloud_firestore/cloud_firestore.dart';

class MessProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "mess_profiles";

  /// Add new mess data
  Future<void> addData({required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionName).add(data);
  }
}
