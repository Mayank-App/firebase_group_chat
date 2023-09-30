import 'package:firebase/ui/round_button.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget{
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.purple,
      ),
   body: Padding(
     padding: const EdgeInsets.only(top:100,right:20,left: 20),
     child: Column(
       children: [
         TextFormField(
               controller: controller,
              decoration: InputDecoration(
                hintText: "Enter Your Email Id",
                border: OutlineInputBorder(),
              ),
            ),
         SizedBox(height: 30,),
         RoundButton(title: "Forgot",
                      loading:loading,
                   onTap: (){
           setState(() {
             loading=true;
           });
           _auth.sendPasswordResetEmail(
               email: controller.text.toString().trim()).then((value){
                 Utils().toastMessage("CODE SENT IN GIVEN EMAIL");
                 setState(() {
                   loading= false;
                 });
           }).onError((error, stackTrace){
             Utils().toastMessage(error.toString());
             setState(() {
               loading = false;
             });
           });

                           },)

       ],
     ),
   ),

   );
  }
}