import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel{
  String id,username,userId,appointmentId,serviceId,serviceName,review,status;
  int rating;


  ReviewModel(this.id, this.username, this.userId, this.appointmentId,
      this.serviceId, this.serviceName, this.review, this.rating,this.status);

  ReviewModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        username = map['username'],
        userId = map['userId'],
        appointmentId = map['appointmentId'],
        serviceId = map['serviceId'],
        serviceName = map['service'],
        review = map['review'],
        rating = map['rating'],
        status = map['status'];



  ReviewModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}