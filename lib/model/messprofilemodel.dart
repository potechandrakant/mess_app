class MessProfileModel {
  String id;
  String? messName;
  String? description;
  String? messTime;
  String? messType;
  String? address;
  String? contactNumber;
  String? emailId;

  MessProfileModel({
    required this.id,
    required this.messName,
    required this.description,
    required this.messTime,
    required this.messType,
    required this.address,
    required this.contactNumber,
    required this.emailId,
  });

  factory MessProfileModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessProfileModel(
      id: docId,
      messName: map['messName'],
      description: map['description'],
      messTime: map['messTime'],
      messType: map['messType'],
      address: map['messLocation'],
      contactNumber: map['mobileNo'],
      emailId: map['emailId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messName': messName,
      'description': description,
      'messTime': messTime,
      'messType': messType,
      'address': address,
      'contactNumber': contactNumber,
      'emailId': emailId,
    };
  }
}
