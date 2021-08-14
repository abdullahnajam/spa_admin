import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_panel/models/appointment_model.dart';
import 'package:spa_admin_panel/models/branch_model.dart';
import 'package:spa_admin_panel/models/coupon_model.dart';
import 'package:spa_admin_panel/models/service_model.dart';
import 'package:spa_admin_panel/models/user_model.dart';
import 'package:spa_admin_panel/screens/branch/branches.dart';
import 'package:spa_admin_panel/screens/navigators/booking_screen.dart';
import 'package:spa_admin_panel/screens/navigators/coupon_screen.dart';
import 'package:spa_admin_panel/screens/navigators/main_screen.dart';

import '../../../../constants.dart';
import 'dart:html';
import 'package:firebase/firebase.dart' as fb;
class BookingList extends StatefulWidget {
  const BookingList({Key? key}) : super(key: key);

  @override
  _BookingListState createState() => _BookingListState();
}


class _BookingListState extends State<BookingList> {




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
            "Bookings",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
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
                  child: Text("No bookings found"),
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
                      label: Text("User"),
                    ),
                    DataColumn(
                      label: Text("Service"),
                    ),

                    DataColumn(
                      label: Text("Date & Time"),
                    ),
                    DataColumn(
                      label: Text("Status"),
                    ),
                    DataColumn(
                      label: Text("Rating"),
                    ),
                    DataColumn(
                      label: Text("Specialist"),
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



Future<void> _showChangeStatusDialog(AppointmentModel model,BuildContext context) async {
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
              height: MediaQuery.of(context).size.height*0.5,
              width: MediaQuery.of(context).size.width*0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Change Status",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
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
                  ListTile(
                    onTap: (){
                      FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                        'status':"Approved"
                      }).then((value) {
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        AwesomeDialog(
                          width: MediaQuery.of(context).size.width*0.3,
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: secondaryColor,
                          title: 'Error : Unable to change status',
                          desc: '${error.toString()}',

                          btnOkOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingScreen()));

                          },
                        )..show();
                      });
                    },
                    title: Text("Approved",style: TextStyle(color: Colors.black),),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    onTap: (){
                      FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                        'status':"Completed"
                      }).then((value) {
                        FirebaseFirestore.instance
                            .collection('customer')
                            .doc(model.userId)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                            UserModel userModel=UserModel.fromMap(data,documentSnapshot.reference.id);
                            int points=userModel.points;
                            points+=model.points;
                            print("points $points");
                            FirebaseFirestore.instance.collection('customer').doc(model.userId).update({
                              'points':points,
                            });

                          }
                        });
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        AwesomeDialog(
                          width: MediaQuery.of(context).size.width*0.3,
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: secondaryColor,
                          title: 'Error : Unable to change status',
                          desc: '${error.toString()}',

                          btnOkOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingScreen()));

                          },
                        )..show();
                      });
                    },
                    title: Text("Completed",style: TextStyle(color: Colors.black),),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    onTap: (){
                      FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                        'status':"Cancelled"
                      }).then((value) {
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        AwesomeDialog(
                          width: MediaQuery.of(context).size.width*0.3,
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: secondaryColor,
                          title: 'Error : Unable to change status',
                          desc: '${error.toString()}',

                          btnOkOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingScreen()));

                          },
                        )..show();
                      });
                    },
                    title: Text("Cancelled",style: TextStyle(color: Colors.black),),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    onTap: (){
                      FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                        'status':"Pending"
                      }).then((value) {
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        AwesomeDialog(
                          width: MediaQuery.of(context).size.width*0.3,
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: secondaryColor,
                          title: 'Error : Unable to change status',
                          desc: '${error.toString()}',

                          btnOkOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingScreen()));

                          },
                        )..show();
                      });
                    },
                    title: Text("Pending",style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final model = AppointmentModel.fromSnapshot(data);
  return DataRow(
      onSelectChanged: (newValue) {
        print('row pressed');
        _showChangeStatusDialog(model, context);
      },
      cells: [
    DataCell(Text(model.name)),
    DataCell(Text(model.serviceName)),
        DataCell(Text("${model.date} ${model.time}")),
        DataCell(Text(model.status)),
        DataCell(model.isRated?Text(model.rating.toString()):Text("Not Rated")),
        DataCell(Text(model.specialistName)),
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
                  title: 'Delete Appointment',
                  desc: 'Are you sure you want to delete this record?',
                  btnCancelOnPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CouponScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('appointments').doc(model.id).delete().then((value) =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CouponScreen())));
                  },
                )..show();
              },
            ),

          ],
        )),

  ]);
}


