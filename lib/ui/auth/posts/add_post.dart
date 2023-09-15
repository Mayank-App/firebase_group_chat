import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/ui/round_button.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:io';

class AddPost extends StatefulWidget{
  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading = false;
 // final databaseRef = FirebaseDatabase.instance.ref("Post");
  final  currentEmail = FirebaseAuth.instance.currentUser?.email;
  final currentPhone = FirebaseAuth.instance.currentUser?.phoneNumber;
  final databaseStore = FirebaseFirestore.instance.collection("user");
  File? _image;
  String newUrl ="";
  var picker = ImagePicker();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;


  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
   return Padding(
       padding: const EdgeInsets.only(bottom: 10,right: 20),
       child: Row(
         children: [
           IconButton(onPressed: () async{
             getImageGallery();
             Image.file(_image!.absolute);
             var id = DateTime.now().millisecondsSinceEpoch.toString();
             firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref( '/foldername/'+id);
             firebase_storage.UploadTask task = ref.putFile(_image!.absolute);
             await Future.value(task);
              newUrl = await ref.getDownloadURL();
              debugPrint(newUrl.toString());
              databaseStore.doc(id).set(
                 {
                   "message" : "",
                   "url" :  newUrl.toString(),
                   "email" : currentPhone ?? currentEmail,
                   "id" : id
                 }
               ).then((value){
                 Utils().toastMessage("Success");
              }).onError((error, stackTrace){
                 Utils().toastMessage("Error ${error.toString()}");
               });

           }, icon:const Icon(Icons.image,size: 35,)),
           Expanded(
             child: TextFormField(
               controller: controller,
               decoration: const InputDecoration(
                   hintText: "What is in your mind?",
                   border: OutlineInputBorder(
                   )
               ),
             ),
           ),
           const SizedBox(width: 20,),
           CircleAvatar(
             backgroundColor: Colors.blue,
             child: IconButton(onPressed: () async{
               setState(() {
                 loading = true;
               });
                var id = DateTime.now().millisecondsSinceEpoch.toString();
                if(controller.text.toString().isNotEmpty && newUrl.isEmpty){
               databaseStore.doc(id).set(
               {
                 "message" :  controller.text.toString().trim(),
                 "email" : currentPhone ?? currentEmail,
                 "id" : id
               }
               ).then((value){
                  controller.clear();
                 setState(() {
                   loading = false;
                 });
                 Utils().toastMessage("Message sent");
               }).onError((error, stackTrace){
                 setState(() {
                   loading= false;
                 });
                 Utils().toastMessage(error.toString());
               });
               }
                else {
                 Utils().toastMessage("Write some message");

                  }
                 },
               icon: const Icon(Icons.send))
           ),
         ],
       ),
     );

  }
  Future getImageGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery );
    if(pickedFile !=null){
      _image=File(pickedFile.path);
    }
    else{
      Utils().toastMessage("No Image Selected");
    }
    setState(() {

    });

  }
}