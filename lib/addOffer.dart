import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_panel/screens/navigators/drawer/side_menu.dart';
import 'package:spa_admin_panel/screens/offers/offers.dart';
import 'package:firebase/firebase.dart' as fb;

import 'constants.dart';
import 'models/offer_model.dart';
class AddOffer extends StatefulWidget {
  const AddOffer({Key? key}) : super(key: key);

  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  String imageUrl="";
  fb.UploadTask? _uploadTask;
  Uri? imageUri;
  bool imageUploading=false;
  List<OfferServices> serviceList=[];
  var nameController=TextEditingController();
  var discountController=TextEditingController();
  var usageController=TextEditingController();
  var startController=TextEditingController();
  var endController=TextEditingController();
  var serviceController=TextEditingController();
  registerOffer(OfferModel model) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('offers').add({
      'name': model.name,
      'image': model.image,
      'discount': model.discount,
      'usage':model.usage,
      'startDate': model.startDate,
      'endDate': model.endDate,
    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  final f = new DateFormat('dd-MM-yyyy');
  DateTime? start;
  DateTime? end;
  final _formKey = GlobalKey<FormState>();
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
  _selectDate(BuildContext context) async {

    start = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (start != null && start != DateTime.now())
      setState(() {
        final f = new DateFormat('dd-MM-yyyy');
        startController.text=f.format(start!).toString();

      });
  }
  _selectEndDate(BuildContext context) async {
    end = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (end != null && end != DateTime.now())
      setState(() {
        final f = new DateFormat('dd-MM-yyyy');
        endController.text=f.format(end!).toString();

      });
  }

  @override
  void initState() {
    startController.text=f.format(DateTime.now()).toString();
    endController.text=f.format(DateTime.now()).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: Form(
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
                    child: Text("Add Offer",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
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
                        "Title",
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
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Date",
                              style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                            ),
                            TextFormField(
                              readOnly: true,
                              onTap: ()=>_selectDate(context),
                              controller:startController,
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
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Date",
                              style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                            ),
                            TextFormField(
                              readOnly: true,
                              onTap: ()=>_selectEndDate(context),
                              controller:endController,
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
                      )
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
                        controller:discountController,
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


                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Usage",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller:usageController,
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
                  SizedBox(height: 10),
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
                        Image.asset("assets/images/placeholder.png",height: 100,width: 100,fit: BoxFit.cover,)
                            :Image.network(imageUrl,height: 100,width: 100,fit: BoxFit.cover,),
                      ),
                      SizedBox(height: 10,),


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
                                                        serviceController.text="";
                                                        OfferServices offerService=new OfferServices(document.reference.id,data['name']);
                                                        serviceList.add(offerService);
                                                        print(serviceList.length);
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
                                                    subtitle: Text("${data['categoryName']}",style: TextStyle(color: Colors.black),),

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
                  Container(
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: serviceList.length,
                      itemBuilder: (BuildContext context,int index){
                        return Text(serviceList[index].name,style: TextStyle(color: Colors.white),);
                      },
                    ),
                  ),

                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){
                      print("ov");
                      if (_formKey.currentState!.validate()) {
                        OfferModel model=new OfferModel(
                            "",
                            nameController.text,
                            imageUrl,
                            discountController.text,
                            startController.text,
                            endController.text,
                            usageController.text
                        );
                        registerOffer(model);
                      }
                    },
                    child: Container(
                      height: 50,
                      color: secondaryColor,
                      alignment: Alignment.center,
                      child: Text("Add Offer",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
