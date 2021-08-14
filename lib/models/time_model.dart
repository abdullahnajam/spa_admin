import 'package:cloud_firestore/cloud_firestore.dart';

class TimeModel{
  String id,time;
  String max,serviceName,serviceId;
  int timeInNumber;

  TimeModel(
      this.id,this.time, this.max, this.serviceName, this.serviceId,this.timeInNumber);

  TimeModel.fromMap(Map<String,dynamic> map,String key)
      : id= key,
        time = map['time'],
        max = map['max'],
        serviceName = map['serviceName'],
        serviceId = map['serviceId'],
        timeInNumber = map['timeInNumber'];




  TimeModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}