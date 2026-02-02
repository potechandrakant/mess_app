class TodaysMenuModel {
  String id;
  String mealName;
  String mealDesc;
  String mealPrice;
  String mealDate;

  TodaysMenuModel({
    required this.id,
    required this.mealName,
    required this.mealDesc,
    required this.mealPrice,
    required this.mealDate,
  });

  factory TodaysMenuModel.fromMap(Map<String, dynamic> map, String docId) {
    return TodaysMenuModel(
      id: docId,
      mealName: map['mealName']?.toString() ?? "",
      mealDesc: map['mealDesc']?.toString() ?? "",
      mealPrice: map['mealPrice']?.toString() ?? "",
      mealDate: map['mealDate']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealName': mealName,
      'mealDesc': mealDesc,
      'mealPrice': mealPrice,
      'mealDate': mealDate,
    };
  }
}
