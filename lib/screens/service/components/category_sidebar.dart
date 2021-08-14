import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_panel/models/category_model.dart';
import 'package:spa_admin_panel/screens/navigators/service_screen.dart';

import '../../../constants.dart';

class CategorySidebar extends StatefulWidget {
  const CategorySidebar({Key? key}) : super(key: key);

  @override
  _CategorySidebarState createState() => _CategorySidebarState();
}

class _CategorySidebarState extends State<CategorySidebar> {

  var categoryController=TextEditingController();
  var tagController=TextEditingController();


  addCategory(String photo,id,name) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('subCategories').add({
      'name': categoryController.text,
      'image': photo,
      'tags':tagController.text,
      'mainCategory':name,
      'mainCategoryId':id,
    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  Future<void> _showAddCategoryDialog(String name,id) async {
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

            /// A "select file/folder" window will appear. User will have to choose a file.
            /// This file will be then read, and uploaded to firebase storage;
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
                              child: Text("Add Sub Category",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category Name",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                          ),
                          TextFormField(
                            controller: categoryController,
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
                            "Category Tags",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                          ),
                          TextFormField(
                            minLines: 2,
                            maxLines: 2,
                            controller: tagController,
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
                              child: Text("Add Image",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          print("tap");
                          addCategory(imageUrl,id,name);
                        },
                        child: Container(
                          height: 50,
                          color: secondaryColor,
                          alignment: Alignment.center,
                          child: Text("Add Sub Category",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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


  Future<void> _showInfoDialog(CategoryModel model,BuildContext context) async {
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
                          child: Text("Category Information",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
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
                          model.tags,
                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey[600]),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.05,),

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
                                Icon(Icons.photo_rounded,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Gender",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(model.gender,style: TextStyle(color: Colors.grey[500])),
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
                                      FirebaseFirestore.instance.collection("categories").doc(model.id).update({
                                        'isFeatured':false
                                      }).then((value) =>
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                                    }
                                    else{
                                      FirebaseFirestore.instance.collection("categories").doc(model.id).update({
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
                                Icon(Icons.category,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Sub Categories",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                _showAddCategoryDialog(model.name, model.id);
                              },
                              child: Text("Add Sub Categories",style: TextStyle(color: Colors.grey[500])),
                            )
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text("Sub Categories",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('subCategories').
                            where("mainCategoryId",isEqualTo: model.id).snapshots(),
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
                                child: Text("No sub categories are added",style: TextStyle(color: Colors.black)),
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
                                      label: Text("Name",style: TextStyle(color: Colors.black)),
                                    ),
                                    DataColumn(
                                      label: Text("Image",style: TextStyle(color: Colors.black)),
                                    ),

                                    DataColumn(
                                      label: Text("Tags",style: TextStyle(color: Colors.black)),
                                    ),


                                    DataColumn(
                                      label: Text("Actions",style: TextStyle(color: Colors.black)),
                                    ),


                                  ],
                                  rows: _buildList(context, snapshot.data!.docs)

                              ),
                            );
                          },
                        ),
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
            "Genders",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          Container(
              margin: EdgeInsets.only(top: defaultPadding),
              padding: EdgeInsets.all(defaultPadding),
              child: Container(
                height: MediaQuery.of(context).size.height*0.2,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('genders').snapshots(),
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
                      return Center(
                        child: Column(
                          children: [
                            Text("No Genders Added")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return new Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: InkWell(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(data['image'],scale: 20),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Text(data['gender']),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_forever,color: Colors.white,),
                                    onPressed: (){
                                      AwesomeDialog(
                                        dialogBackgroundColor: secondaryColor,
                                        width: MediaQuery.of(context).size.width*0.3,
                                        context: context,
                                        dialogType: DialogType.QUESTION,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Delete Gender',
                                        desc: 'Are you sure you want to delete this record?',
                                        btnCancelOnPress: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen()));
                                        },
                                        btnOkOnPress: () {
                                          FirebaseFirestore.instance.collection('genders').doc(document.reference.id).delete().then((value) =>
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                                        },
                                      )..show();
                                    },
                                  ),

                                ),
                              ),
                            )
                        );
                      }).toList(),
                    );
                  },
                ),
              )
          ),
          Text(
            "Categories",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: defaultPadding),
          Container(
              margin: EdgeInsets.only(top: defaultPadding),
              padding: EdgeInsets.all(defaultPadding),
              child: Container(
                height: MediaQuery.of(context).size.height*0.4,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
                      return Center(
                        child: Column(
                          children: [
                            Text("No Category Added")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        CategoryModel model=CategoryModel.fromMap(data, document.reference.id);
                        return new Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: InkWell(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(data['image']),
                                    backgroundColor: Colors.indigoAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                  subtitle: InkWell(
                                    onTap: (){
                                      _showInfoDialog(model, context);
                                    },
                                    child: Text("view details",style: TextStyle(color: Colors.white),),
                                  ),
                                  title: Text(data['name']),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_forever,color: Colors.white,),
                                    onPressed: (){
                                      AwesomeDialog(
                                        dialogBackgroundColor: secondaryColor,
                                        width: MediaQuery.of(context).size.width*0.3,
                                        context: context,
                                        dialogType: DialogType.QUESTION,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Delete Category',
                                        desc: 'Are you sure you want to delete this record?',
                                        btnCancelOnPress: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen()));
                                        },
                                        btnOkOnPress: () {
                                          FirebaseFirestore.instance.collection('categories').doc(document.reference.id).delete().then((value) =>
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen())));
                                        },
                                      )..show();
                                    },
                                  ),

                                ),
                              ),
                            )
                        );
                      }).toList(),
                    );
                  },
                ),
              )
          ),
        ],
      ),
    );
  }
}
List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return  snapshot.map((data) => _buildListItem(context, data)).toList();
}
DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final model = SubCategoryModel.fromSnapshot(data);
  return DataRow(

      cells: [
        DataCell(Text(model.name,style: TextStyle(color: Colors.black))),
        DataCell(Image.network(model.image,width: 50,height: 50,fit: BoxFit.cover,)),
        DataCell(Text(model.tags,maxLines: 1,style: TextStyle(color: Colors.black))),

        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.delete_forever),
              color: Colors.grey,
              onPressed: (){
                FirebaseFirestore.instance.collection('subCategories').doc(model.id).delete();
              },
            ),

          ],
        )),

      ]);
}


