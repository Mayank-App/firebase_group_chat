import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/auth/posts/add_post.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PostScreen extends StatefulWidget{
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final _auth = FirebaseAuth.instance;
  final  currentEmail = FirebaseAuth.instance.currentUser?.email;
  final  curentPhone = FirebaseAuth.instance.currentUser?.phoneNumber;
 // final databaseRef = FirebaseDatabase.instance.ref("Post");
  final databaseStore = FirebaseFirestore.instance.collection("user").snapshots();
  final databaseStore1 = FirebaseFirestore.instance.collection("user");
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar:  AppBar(
     backgroundColor:  const Color.fromRGBO(50, 51, 60, 1),
       leading: IconButton(
         icon: const Icon(Icons.arrow_back, color: Colors.blue),
         onPressed: (){}
       ),
       title: const Row(
         children: [
           CircleAvatar(
             backgroundImage: NetworkImage("https://e1.pxfuel.com/desktop-wallpaper/226/202/desktop-wallpaper-jai-kishan-phulwani-on-lord-shiva-bhagwa-flag.jpg")
           ),
           SizedBox(width: 15),
           Text("हिंदुत्व",style: TextStyle(color: Colors.white),),
         ],
       ),
       actions: [
         IconButton(onPressed: (){
           _auth.signOut().then((value){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
           });
         }, icon: const Icon(Icons.logout_outlined,color: Colors.blue,))
       ],
     ),
     body: Container(
           decoration: const BoxDecoration(
             image: DecorationImage(
               image: NetworkImage("https://i.pinimg.com/originals/ab/ab/60/abab60f06ab52fa7846593e6ae0c9a0b.png"),
                   fit: BoxFit.fill
             )
           ),
       child: Column(
         children: [
           Expanded(
             child: StreamBuilder<QuerySnapshot>(
           stream: databaseStore,
         builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const CircularProgressIndicator();
           }
           if (snapshot.hasError) {
             return const Text("Error");
           }

             return ListView.builder(
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context, index) {

                   return Padding(
                     padding: const EdgeInsets.only(bottom: 10),
                     child: Row(
                       mainAxisAlignment: snapshot.data!.docs[index]["email"]
                           .toString() == curentPhone ||
                           snapshot.data!.docs[index]["email"].toString()
                               == currentEmail
                           ? MainAxisAlignment.end
                           : MainAxisAlignment.start,
                       children: [
                         InkWell(
                           child: Container(
                             constraints: const BoxConstraints(
                                 maxWidth: 275
                             )
                             , child: Card(
                               color: Colors.green.shade400
                               , child: Padding(
                             padding: const EdgeInsets.all(10.0),
                             child:
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(snapshot.data!.docs[index]["email"]
                                     .toString(),
                                   style: const TextStyle(fontSize: 12,
                                       fontStyle: FontStyle.italic,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.brown),),
                                 const SizedBox(height: 5,),
                                 if (snapshot.data!.docs[index]["message"].toString().isEmpty) SizedBox(
                                     height: 100,
                                     child: fetchImage(snapshot.data!.docs[index]["url"]))
                                 else Text(snapshot.data!.docs[index]["message"].toString(), style: const TextStyle(color: Colors.black, fontSize: 14),),
                               ],
                             )

                           )),
                         ),
                           onLongPress: (){
                             alertBox(snapshot.data!
                                 .docs[index]["message"]
                                 .toString(),
                                 index,
                                 snapshot);
                           } ,
                         )
                       ],

                     ),
                   );
                 }

             );
           }

             )
           ),
           Padding(
             padding: const EdgeInsets.only(left: 10,bottom: 10),
             child: AddPost(),
           ),
         ],
       ),
     ),
   );
  }
  Future<void> alertBox ( String title  , int index,AsyncSnapshot<QuerySnapshot> snapshot) async{
    controller.text = title;
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: "update",
                  border: OutlineInputBorder()
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);

              }, child: const Text("Cancel")),
              TextButton(onPressed: (){
               Navigator.pop(context);
                databaseStore1.doc(snapshot.data!.docs[index]["id"].toString()).update(
                    {
                      "message" : controller.text.toString().trim()
                    }
                ).then((value){
                Utils().toastMessage("Update");
                }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
                });
              }, child: const Text("Update")),
              TextButton(onPressed: ()  async {
                databaseStore1.doc(snapshot.data!
                    .docs[index]["id"].toString())
                    .delete();
                Navigator.pop(context);
                firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref( '/foldername/'+snapshot.data!
                    .docs[index]["id"].toString());
                await ref.delete();
              },
                  child: Text("Delete"))

            ],
          );
        }
      );
    }

    Widget fetchImage(url)
    {
      return Image.network(url, fit: BoxFit.fill,);
    }

}