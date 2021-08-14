import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel{
  String id,name,image,serviceName,serviceId,discount,discountType,startDate,endDate,code, usage;


  CouponModel(
      this.id,
      this.name,
      this.image,
      this.serviceName,
      this.serviceId,
      this.discount,
      this.discountType,
      this.code,
      this.startDate,
      this.endDate,
      this.usage);

  CouponModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        image = map['image'],
        serviceName = map['serviceName'],
        serviceId = map['serviceId'],
        discount = map['discount'],
        discountType = map['discountType'],
        code = map['code'],
        startDate = map['startDate'],
        endDate = map['endDate'],
        usage = map['usage'];



  CouponModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}