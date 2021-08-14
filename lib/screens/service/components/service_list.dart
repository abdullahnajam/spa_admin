import 'dart:html';
import 'package:firebase/firebase.dart' as fb;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_panel/models/branch_model.dart';
import 'package:spa_admin_panel/models/service_model.dart';
import 'package:spa_admin_panel/models/time_model.dart';
import 'package:spa_admin_panel/screens/branch/branches.dart';
import 'package:spa_admin_panel/screens/navigators/booking_screen.dart';
import 'package:spa_admin_panel/screens/navigators/main_screen.dart';
import 'package:spa_admin_panel/screens/navigators/service_screen.dart';

import '../../../../constants.dart';

class ServiceList extends StatefulWidget {

  @override
  _ServiceListState createState() => _ServiceListState();
}


class _ServiceListState extends State<ServiceList> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Services",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('services').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.size==0){
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(80),
                  alignment: Alignment.center,
                  child: Text("No services are added"),
                );
              }
              print("size ${snapshot.data!.size}");
              return new SizedBox(
                width: double.infinity,
                child: DataTable2(

                    showCheckboxColumn: false,
                  columnSpacing: defaultPadding,
                  minWidth: 600,
                  columns: [
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("Arabic Name"),
                    ),
                    DataColumn(
                      label: Text("price"),
                    ),

                    DataColumn(
                      label: Text("Rating"),
                    ),

                    DataColumn(
                      label: Text("Category"),
                    ),
                    DataColumn(
                      label: Text("Time Slots"),
                    ),

                    DataColumn(
                      label: Text("Actions"),
                    ),


                  ],
                  rows: _buildList(context, snapshot.data!.docs)

                ),
              );
            },
          ),


        ],
      ),
    );
  }
}
List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return  snapshot.map((data) => _buildListItem(context, data)).toList();
}



var nameController=TextEditingController();
var nameARController=TextEditingController();
var desController=TextEditingController();
var desArController=TextEditingController();
var priceController=TextEditingController();
var categoryName=TextEditingController();
var gender=TextEditingController();
var tagsController=TextEditingController();
var pointsController=TextEditingController();



updateService(ServiceModel model,BuildContext context) async{
  final ProgressDialog pr = ProgressDialog(context: context);
  pr.show(max: 100, msg: "Loading");
  FirebaseFirestore.instance.collection('services').doc(model.id).update({
    'name': model.name,
    'name_ar': model.name_ar,
    'image': model.image,
    'gender': model.gender,
    'categoryName': model.categoryName,
    'categoryId': model.categoryId,
    'rating': model.rating,
    'totalRating':model.totalRating,
    'price': model.price,
  }).then((value) {
    pr.close();
    print("added");
    Navigator.pop(context);
  });
}


Future<void> _showEditService(ServiceModel model,BuildContext context) async {
  String imageUrl="";
  fb.UploadTask? _uploadTask;
  Uri imageUri;
  String? categoryId,genderId;
  bool imageUploading=false;
  bool isActive=model.isActive;
  bool isFeatured=model.isFeatured;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();

          nameController.text=model.name;
          nameARController.text=model.name_ar;
          desController.text=model.description;
          desArController.text=model.description_ar;
          priceController.text=model.price;
          categoryName.text=model.categoryName;
          gender.text=model.gender;
          tagsController.text=model.tags;
          pointsController.text=model.points.toString();
          

          uploadToFirebase(File imageFile) async {
            final filePath = 'images/${DateTime.now()}.png';
            print("put");
            setState((){
              imageUploading=true;
              _uploadTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
            });

            fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
            imageUri = await taskSnapshot.ref.getDownloadURL();
            setState((){
              print("heer");
              imageUrl=imageUri.toString();
              imageUploading=false;
              print(imageUrl);
            });

          }
          uploadImage() async {
            // HTML input element
            FileUploadInputElement uploadInput = FileUploadInputElement();
            uploadInput.click();

            uploadInput.onChange.listen(
                  (changeEvent) {
                final file = uploadInput.files!.first;
                final reader = FileReader();
                reader.readAsDataUrl(file);
                reader.onLoadEnd.listen(
                      (loadEndEvent) async {
                    uploadToFirebase(file);
                  },
                );
              },
            );
          }


          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height*0.9,
              width: MediaQuery.of(context).size.width*0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Edit Service",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: IconButton(
                              icon: Icon(Icons.close,color: Colors.grey,),
                              onPressed: ()=>Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),

                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: nameController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name (Arabic)",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: nameARController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                maxLines: 3,
                                minLines: 3,
                                controller: desController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description (Arabc)",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                maxLines: 3,
                                minLines: 3,
                                controller: desArController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Price",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: priceController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tags",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                maxLines: 2,
                                minLines: 2,
                                controller: tagsController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Points",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: pointsController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          CheckboxListTile(

                            title: const Text('Active',style: TextStyle(color: Colors.black),),
                            value: isActive,
                            onChanged: (bool? value) {
                              setState(() {
                                isActive = value!;
                              });
                            },
                            secondary: const Icon(Icons.timer,color: Colors.black,),
                          ),
                          SizedBox(height: 10,),
                          CheckboxListTile(

                            title: const Text('Featured',style: TextStyle(color: Colors.black),),
                            value: isFeatured,
                            onChanged: (bool? value) {
                              setState(() {
                                isFeatured = value!;
                              });
                            },
                            secondary: const Icon(Icons.star,color: Colors.black,),
                          ),
                          
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return StatefulBuilder(
                                          builder: (context,setState){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              insetAnimationDuration: const Duration(seconds: 1),
                                              insetAnimationCurve: Curves.fastOutSlowIn,
                                              elevation: 2,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('genders').snapshots(),
                                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                            Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return Center(
                                                        child: CircularProgressIndicator(),
                                                      );
                                                    }
                                                    if (snapshot.data!.size==0){
                                                      return Center(
                                                          child: Text("No Genders Added",style: TextStyle(color: Colors.black))
                                                      );

                                                    }

                                                    return new ListView(
                                                      shrinkWrap: true,
                                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                        return new Padding(
                                                          padding: const EdgeInsets.only(top: 15.0),
                                                          child: ListTile(
                                                            onTap: (){
                                                              setState(() {
                                                                gender.text="${data['gender']}";
                                                                genderId=document.reference.id;
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            leading: CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage: NetworkImage(data['image']),
                                                              backgroundColor: Colors.indigoAccent,
                                                              foregroundColor: Colors.white,
                                                            ),
                                                            title: Text("${data['gender']}",style: TextStyle(color: Colors.black),),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                  );
                                },
                                controller: gender,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Category",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return StatefulBuilder(
                                          builder: (context,setState){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              insetAnimationDuration: const Duration(seconds: 1),
                                              insetAnimationCurve: Curves.fastOutSlowIn,
                                              elevation: 2,
                                              child: Container(
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                            Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return Center(
                                                        child: CircularProgressIndicator(),
                                                      );
                                                    }
                                                    if (snapshot.data!.size==0){
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                            Text("No Categories Added",style: TextStyle(color: Colors.black))

                                                          ],
                                                        ),
                                                      );

                                                    }

                                                    return new ListView(
                                                      shrinkWrap: true,
                                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                        return new Padding(
                                                          padding: const EdgeInsets.only(top: 15.0),
                                                          child: ListTile(
                                                            onTap: (){
                                                              setState(() {
                                                                categoryName.text="${data['name']}";
                                                                categoryId=document.reference.id;
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            leading: CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage: NetworkImage(data['image']),
                                                              backgroundColor: Colors.indigoAccent,
                                                              foregroundColor: Colors.white,
                                                            ),
                                                            title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                  );
                                },
                                controller: categoryName,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 200,
                                width: 250,
                                child: imageUploading?Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Uploading",style: TextStyle(color: primaryColor),),
                                      SizedBox(width: 10,),
                                      CircularProgressIndicator()
                                    ],),
                                ):imageUrl==""?
                                Image.network(model.image,height: 100,width: 100,fit: BoxFit.cover,)
                                    :Image.network(imageUrl,height: 100,width: 100,fit: BoxFit.cover,),
                              ),

                              InkWell(
                                onTap: (){
                                  uploadImage();
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*0.15,
                                  color: secondaryColor,
                                  alignment: Alignment.center,
                                  child: Text("Add Photo",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                ),
                              )
                            ],
                          ),


                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              print("tap");
                              ServiceModel newModel=new ServiceModel(
                                model.id,
                                nameController.text,
                                nameARController.text,
                                desController.text,
                                desArController.text,
                                isFeatured,
                                imageUrl==""?model.image:imageUrl,
                                gender.text,
                                categoryName.text,
                                categoryId==null?model.categoryId:categoryId!,
                                model.rating,
                                priceController.text,
                                model.totalRating,
                                tagsController.text,
                                isActive,
                                int.parse(pointsController.text),
                                genderId==null?model.genderId:genderId!,
                                

                              );
                              updateService(newModel,context);
                            },
                            child: Container(
                              height: 50,
                              color: secondaryColor,
                              alignment: Alignment.center,
                              child: Text("Update Service",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> _showAddGalleryDialog(BuildContext context,String id) async {
  String imageUrl="";
  fb.UploadTask? _uploadTask;
  Uri imageUri;
  bool imageUploading=false;
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){
          uploadToFirebase(File imageFile) async {
            final filePath = 'images/${DateTime.now()}.png';

            print("put");
            setState((){
              imageUploading=true;
              _uploadTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
            });

            fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
            imageUri = await taskSnapshot.ref.getDownloadURL();
            setState((){
              print("heer");
              imageUrl=imageUri.toString();
              imageUploading=false;
              //imageUrl= "https://firebasestorage.googleapis.com/v0/b/accesfy-882e6.appspot.com/o/bookingPics%2F1622649147001?alt=media&token=45a4483c-2f29-48ab-bcf1-813fd8fa304b";
              print(imageUrl);
            });

          }

          uploadImage() async {
            // HTML input element
            FileUploadInputElement uploadInput = FileUploadInputElement();
            uploadInput.click();

            uploadInput.onChange.listen(
                  (changeEvent) {
                final file = uploadInput.files!.first;
                final reader = FileReader();
                // The FileReader object lets web applications asynchronously read the
                // contents of files (or raw data buffers) stored on the user's computer,
                // using File or Blob objects to specify the file or data to read.
                // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader

                reader.readAsDataUrl(file);
                // The readAsDataURL method is used to read the contents of the specified Blob or File.
                //  When the read operation is finished, the readyState becomes DONE, and the loadend is
                // triggered. At that time, the result attribute contains the data as a data: URL representing
                // the file's data as a base64 encoded string.
                // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL

                reader.onLoadEnd.listen(
                  // After file finiesh reading and loading, it will be uploaded to firebase storage
                      (loadEndEvent) async {
                    uploadToFirebase(file);
                  },
                );
              },
            );
          }
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              width: MediaQuery.of(context).size.width*0.5,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Add Gallery Image",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: IconButton(
                              icon: Icon(Icons.close,color: Colors.grey,),
                              onPressed: ()=>Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 100,
                          width: 150,
                          child: imageUploading?Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Uploading",style: TextStyle(color: primaryColor),),
                                SizedBox(width: 10,),
                                CircularProgressIndicator()
                              ],),
                          ):imageUrl==""?
                          Image.asset("assets/images/placeholder.png",height: 100,width: 150,fit: BoxFit.cover,)
                              :Image.network(imageUrl,height: 100,width: 150,fit: BoxFit.cover,),
                        ),

                        InkWell(
                          onTap: (){
                            uploadImage();
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width*0.15,
                            color: secondaryColor,
                            alignment: Alignment.center,
                            child: Text("Select Image",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 15,),
                    InkWell(
                      onTap: (){
                        final ProgressDialog pr = ProgressDialog(context: context);
                        pr.show(max: 100, msg: "Adding");
                        FirebaseFirestore.instance.collection('gallery').add({
                          'serviceId': id,
                          'image': imageUrl,
                        }).then((value) {
                          pr.close();
                          print("added");
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: 50,
                        color: secondaryColor,
                        alignment: Alignment.center,
                        child: Text("Add",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
Future<void> _showViewGalleryDialog(BuildContext context,String id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){
          final orientation = MediaQuery.of(context).orientation;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              width: MediaQuery.of(context).size.width*0.5,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Gallery",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: IconButton(
                            icon: Icon(Icons.close,color: Colors.grey,),
                            onPressed: ()=>Navigator.pop(context),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('gallery').where("serviceId",isEqualTo: id).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                              Text("Something Went Wrong")

                            ],
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.size==0){
                        return Container(
                            alignment: Alignment.center,
                            child:Text("No Pictures")

                        );

                      }
                      return new GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          //ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
                          return Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:NetworkImage(data['image']),
                                  fit: BoxFit.cover,
                                )
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              )
            ),
          );
        },
      );
    },
  );
}



Future<void> _showInfoDialog(ServiceModel model,BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        insetAnimationDuration: const Duration(seconds: 1),
        insetAnimationCurve: Curves.fastOutSlowIn,
        elevation: 2,

        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height*0.6,
          width: MediaQuery.of(context).size.width*0.5,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text("Service Information",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: IconButton(
                          icon: Icon(Icons.close,color: Colors.grey,),
                          onPressed: ()=>Navigator.pop(context),
                        ),
                      ),
                    )
                  ],
                ),

                Expanded(
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${model.name}",
                            style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "-",
                            style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "${model.name_ar}",
                            style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        model.description,
                        style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        model.description_ar,
                        style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey[600]),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.streetview,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Category",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            "${model.categoryName}",
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Gender",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            "${model.gender}",
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.monetization_on,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Price",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            "${model.price}",
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Rating",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            "${model.rating}",
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.score,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Points",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            "${model.points}",
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Active",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              AwesomeDialog(
                                width: MediaQuery.of(context).size.width*0.3,
                                context: context,
                                dialogType: DialogType.QUESTION,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: secondaryColor,
                                title: 'Change Active',
                                desc: 'Are you sure you want to change its active status?',
                                btnCancelOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen()));
                                },
                                btnOkOnPress: () {
                                  if(model.isFeatured){
                                    FirebaseFirestore.instance.collection("services").doc(model.id).update({
                                      'isActive':false
                                    }).then((value) =>
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                                  }
                                  else{
                                    FirebaseFirestore.instance.collection("services").doc(model.id).update({
                                      'isActive':true
                                    }).then((value) =>
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                                  }
                                },
                              )..show();
                            },
                            child: Text(
                              "${model.isActive}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Featured",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              AwesomeDialog(
                                width: MediaQuery.of(context).size.width*0.3,
                                context: context,
                                dialogType: DialogType.QUESTION,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: secondaryColor,
                                title: 'Change Featured',
                                desc: 'Are you sure you want to change its featured status?',
                                btnCancelOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen()));
                                },
                                btnOkOnPress: () {
                                  if(model.isFeatured){
                                    FirebaseFirestore.instance.collection("services").doc(model.id).update({
                                      'isFeatured':false
                                    }).then((value) =>
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                                  }
                                  else{
                                    FirebaseFirestore.instance.collection("services").doc(model.id).update({
                                      'isFeatured':true
                                    }).then((value) =>
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                                  }
                                },
                              )..show();

                            },
                            child: Text(
                              "${model.isFeatured}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          )
                        ],
                      ),



                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.photo_library,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Gallery",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: (){
                                  _showViewGalleryDialog(context, model.id);
                                },
                                child: Text(
                                  "View Gallery",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: defaultPadding,),
                              InkWell(
                                onTap: (){
                                  _showAddGalleryDialog(context, model.id);
                                },
                                child: Text(
                                  "Add Photo",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.photo_library,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Time Slot",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              _showAddTimeDialog(context);
                            },
                            child: Text(
                              "Add New",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.photo_rounded,color: Colors.grey[600],size: 20,),
                              Text(
                                "   Photo",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Image.network(model.image,fit: BoxFit.cover,width: 50,height: 50,)
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.analytics_sharp,color: Colors.grey[600],size: 20,),
                              Text(
                                "   SEO Tags",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            "${model.tags}",
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300],),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Time Slots",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                            ),
                          ),
                        ],
                      ),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('timeslots').
                        where("serviceId",isEqualTo: model.id).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              margin: EdgeInsets.all(30),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data!.size==0){
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: Text("No time slots",style: TextStyle(color: Colors.black)),
                            );
                          }
                          print("size ${snapshot.data!.size}");
                          return new SizedBox(
                            width: double.infinity,
                            child: DataTable2(

                                showCheckboxColumn: false,
                                columnSpacing: defaultPadding,
                                minWidth: 600,
                                columns: [
                                  DataColumn(
                                    label: Text("Time",style: TextStyle(color: Colors.black)),
                                  ),
                                  DataColumn(
                                    label: Text("Limit",style: TextStyle(color: Colors.black)),
                                  ),
                                  DataColumn(
                                    label: Text("Actions",style: TextStyle(color: Colors.black)),
                                  ),


                                ],
                                rows: _buildTimeList(context, snapshot.data!.docs)

                            ),
                          );
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

var maxController=TextEditingController();
var serviceController=TextEditingController();
var timeController=TextEditingController();
String? serviceId;int? timeInNumber;
TimeOfDay _time = TimeOfDay(hour: 12, minute: 00);

register(BuildContext context) async{
  final ProgressDialog pr = ProgressDialog(context: context);
  pr.show(max: 100, msg: "Adding");
  FirebaseFirestore.instance.collection('timeslots').doc("T$timeInNumber").set({
    'time': timeController.text,
    'max': maxController.text,
    'serviceName': serviceController.text,
    'serviceId': serviceId,
    'timeInNumber':timeInNumber
  }).then((value) {
    pr.close();
    print("added");
    Navigator.pop(context);

  }).onError((error, stackTrace) {
    pr.close();
    AwesomeDialog(
      width: MediaQuery.of(context).size.width*0.3,
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      dialogBackgroundColor: secondaryColor,
      title: 'Error',
      desc: '${error.toString()}',

      btnOkOnPress: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingScreen()));

      },
    )..show();
  });

}


Future<void> _showAddTimeDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height*0.55,
              width: MediaQuery.of(context).size.width*0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Add Time Slot",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: IconButton(
                              icon: Icon(Icons.close,color: Colors.grey,),
                              onPressed: ()=>Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),

                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Time",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                onTap: ()async{
                                  final TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 7, minute: 15),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  );
                                  if (newTime != null) {
                                    setState(() {
                                      String period=newTime.period.toString();
                                      period="${period[period.length-2]}${period[period.length-1]}";
                                      period=period.toUpperCase();
                                      String minutes=newTime.minute.toString();
                                      if(newTime.minute.toString().length==1)
                                        minutes="0$minutes";
                                      timeController.text = "${newTime.hourOfPeriod}:$minutes $period";
                                      if(period=="AM"){
                                        timeInNumber=int.parse("${newTime.hourOfPeriod}$minutes");
                                      }
                                      else{
                                        timeInNumber=int.parse("${newTime.hourOfPeriod+12}$minutes");
                                      }
                                    });
                                  }
                                },
                                readOnly: true,
                                controller: timeController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Capacity",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: maxController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Service",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return StatefulBuilder(
                                          builder: (context,setState){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              insetAnimationDuration: const Duration(seconds: 1),
                                              insetAnimationCurve: Curves.fastOutSlowIn,
                                              elevation: 2,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('services').snapshots(),
                                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                            Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return Center(
                                                        child: CircularProgressIndicator(),
                                                      );
                                                    }
                                                    if (snapshot.data!.size==0){
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                            Text("No Services Added",style: TextStyle(color: Colors.black))

                                                          ],
                                                        ),
                                                      );

                                                    }

                                                    return new ListView(
                                                      shrinkWrap: true,
                                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                        return new Padding(
                                                          padding: const EdgeInsets.only(top: 15.0),
                                                          child: ListTile(
                                                            onTap: (){
                                                              setState(() {
                                                                serviceController.text="${data['name']}";
                                                                serviceId=document.reference.id;
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            leading: CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage: NetworkImage(data['image']),
                                                              backgroundColor: Colors.indigoAccent,
                                                              foregroundColor: Colors.white,
                                                            ),
                                                            subtitle: Text("${data['categoryName']}",style: TextStyle(color: Colors.black),),
                                                            title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                  );
                                },
                                controller:serviceController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),



                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              if (_formKey.currentState!.validate()) {
                                register(context);
                              }
                            },
                            child: Container(
                              height: 50,
                              color: secondaryColor,
                              alignment: Alignment.center,
                              child: Text("Add",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}



DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final model = ServiceModel.fromSnapshot(data);
  return DataRow(
      onSelectChanged: (newValue) {
        print('row pressed');
        _showInfoDialog(model, context);
      },
      cells: [
    DataCell(Text(model.name)),
        DataCell(Text(model.name_ar)),
    DataCell(Text(model.price.toString())),
        DataCell(Text(model.rating.toString())),
        DataCell(Text(model.categoryName)),
        DataCell(
          InkWell(
            onTap: (){

            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text("View Slots"),
            ),
          )
        ),

        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.delete_forever),
              color: Colors.white,
              onPressed: (){
                AwesomeDialog(
                  width: MediaQuery.of(context).size.width*0.3,
                  context: context,
                  dialogType: DialogType.QUESTION,
                  animType: AnimType.BOTTOMSLIDE,
                  dialogBackgroundColor: secondaryColor,
                  title: 'Delete Service',
                  desc: 'Are you sure you want to delete this record?',
                  btnCancelOnPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('services').doc(model.id).delete().then((value) =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                  },
                )..show();
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: (){
                _showEditService(model, context);
              },
            ),
          ],
        )),

  ]);
}


//time slots
List<DataRow> _buildTimeList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return  snapshot.map((data) => _buildTimeListItem(context, data)).toList();
}
DataRow _buildTimeListItem(BuildContext context, DocumentSnapshot data) {
  final model = TimeModel.fromSnapshot(data);
  return DataRow(

      cells: [
        DataCell(Text(model.time,style: TextStyle(color: Colors.black))),
        DataCell(Text(model.max,maxLines: 1,style: TextStyle(color: Colors.black))),

        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.delete_forever),
              color: Colors.grey,
              onPressed: (){
                FirebaseFirestore.instance.collection('timeslots').doc(model.id).delete();
              },
            ),

          ],
        )),

      ]);
}


