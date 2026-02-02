class Customerprofilemodel {
  String id;
  String? customerName;
  String? emailId;
  String? mobileNo;

  Customerprofilemodel({
    required this.id,
    required this.customerName,
    required this.emailId,
    required this.mobileNo,
  });

  factory Customerprofilemodel.fromMap(Map<String, dynamic> map, String docId) {
    return Customerprofilemodel(
      id: docId,
      customerName: map['customerName'],
      emailId: map['emailId'],
      mobileNo: map['mobileNo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'emailId': emailId,
      'mobileNo': mobileNo,
    };
  }
}
