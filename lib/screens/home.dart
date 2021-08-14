import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_panel/models/appointment_model.dart';
import 'package:spa_admin_panel/models/calendar.dart';
import 'package:spa_admin_panel/models/coupon_model.dart';
import 'package:spa_admin_panel/models/offer_model.dart';
import 'package:spa_admin_panel/models/service_model.dart';
import 'package:spa_admin_panel/screens/booking/components/booking_list.dart';
import 'package:spa_admin_panel/screens/branch/components/branch_list.dart';
import 'package:spa_admin_panel/screens/coupon/components/coupon_list.dart';
import 'package:spa_admin_panel/screens/service/components/category_sidebar.dart';
import 'package:spa_admin_panel/screens/service/components/service_list.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../constants.dart';
import 'package:firebase/firebase.dart' as fb;

import '../../header.dart';
import '../../responsive.dart';

class Home extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  Home(this._scaffoldKey);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Home",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: defaultPadding),
                      if (Responsive.isDesktop(context) ||Responsive.isTablet(context))
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Users",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('customer').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.person,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Branch",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('branches').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.pie_chart,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Services",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('services').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.spa,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Categories",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.category,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isMobile(context))
                        Column(
                          children: [
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Users",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('customer').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.person,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Branch",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('branches').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.pie_chart,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Services",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('services').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.spa,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Categories",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.category,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: defaultPadding),
                      Text(
                        "Statistics",
                        style: Theme.of(context).textTheme.headline4!.apply(color:Colors.white),
                      ),
                      SizedBox(height: defaultPadding),
                      Text(
                        "Appointments",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      if (Responsive.isDesktop(context) ||Responsive.isTablet(context))
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pending",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('appointments')
                                              .where("status",isEqualTo: "Pending").snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "${snapshot.data!.size}",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.assignment_returned,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Completed",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('appointments')
                                              .where("status",isEqualTo: "Completed").snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "${snapshot.data!.size}",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.assignment_turned_in,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cancelled",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('appointments')
                                              .where("status",isEqualTo: "Cancelled").snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "${snapshot.data!.size}",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.assignment_late_rounded,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Revenue",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('appointments')
                                              .where("status",isEqualTo: "Completed").snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "0",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.monetization_on,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        Column(
                          children: [
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pending",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('appointments')
                                            .where("status",isEqualTo: "Pending").snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.assignment_returned,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Completed",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('appointments')
                                            .where("status",isEqualTo: "Completed").snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.assignment_turned_in,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cancelled",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('appointments')
                                            .where("status",isEqualTo: "Cancelled").snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.assignment_late_rounded,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Revenue",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('appointments')
                                            .where("status",isEqualTo: "Completed").snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "0",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.monetization_on,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: defaultPadding),
                      Text(
                        "Services",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      if (Responsive.isDesktop(context) ||Responsive.isTablet(context))
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Offers",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('offers').snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "${snapshot.data!.size}",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.local_offer,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Coupons",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('coupons').snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "${snapshot.data!.size}",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.add_shopping_cart_outlined,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Specialists",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('specialists').snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "${snapshot.data!.size}",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.person,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:EdgeInsets.all(defaultPadding),
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pending Reviews",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        SizedBox(height: defaultPadding),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('reviews')
                                              .where("status",isEqualTo: "Pending").snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error');
                                            }
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Text(
                                                "-",
                                                style: Theme.of(context).textTheme.subtitle2,
                                              );
                                            }
                                            return Text(
                                              "${snapshot.data!.size}",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: Icon(Icons.star_half,color: Colors.white,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        Column(
                          children: [
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Offers",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('offers').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.local_offer,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Coupons",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('coupons').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.add_shopping_cart_outlined,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cancelled",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('appointments')
                                            .where("status",isEqualTo: "Cancelled").snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.assignment_late_rounded,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.all(defaultPadding),
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pending Reviews",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      SizedBox(height: defaultPadding),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('reviews')
                                            .where("status",isEqualTo: "Pending").snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error');
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              "-",
                                              style: Theme.of(context).textTheme.subtitle2,
                                            );
                                          }
                                          return Text(
                                            "${snapshot.data!.size}",
                                            style: Theme.of(context).textTheme.subtitle2,
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.star_half,color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),



              ],
            )
          ],
        ),
      ),
    );
  }
}
