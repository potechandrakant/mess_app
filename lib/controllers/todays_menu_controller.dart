import 'package:cloud_firestore/cloud_firestore.dart';

class TodaysMenuController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "Breakfast";

  /// Add new mess data
  Future<void> addData({required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionName).add(data);
  }
}
