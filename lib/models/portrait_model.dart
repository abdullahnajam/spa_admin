import 'package:cloud_firestore/cloud_firestore.dart';

class PortraitModel{
  String id,linkId,type,name,image,language,status,gender;


  PortraitModel(this.id, this.linkId, this.type, this.name, this.image,this.language,this.status,this.gender);

  PortraitModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        image = map['image'],
        linkId = map['linkId'],
        type = map['type'],
        name = map['name'],
        language = map['language'],
        status = map['status'],
        gender = map['gender'];



  PortraitModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}