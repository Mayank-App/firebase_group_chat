import 'package:firebase/ui/auth/verify_code.dart';
import 'package:firebase/ui/round_button.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget{
  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  var loading = false;
  final controller = TextEditingController();
  final _auth =   FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            TextFormField(
              keyboardType: TextInputType.number,
              controller:  controller,
              decoration: InputDecoration(
                hintText: "+1 234 5678 987"
              ),
            ),
            SizedBox(height: 50,),
            RoundButton(title: "Login",
                loading: loading,
                onTap: (){
              setState(() {
                loading = true;
              });

               _auth.verifyPhoneNumber(
                 phoneNumber: controller.text,
                   verificationCompleted: (_){
                   setState(() {
                     loading =false;
                   });
                   },
                   verificationFailed: (e){
                   setState(() {
                     loading=false;
                   });
                   Utils().toastMessage(e.toString());
                   },
                   codeSent: (String verificationId,int? token ){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCode(
                       verification:verificationId  ,
                     )));
                     setState(() {
                       loading=false;
                     });
                   },
                   codeAutoRetrievalTimeout: (e){
                   setState(() {
                     loading=false;
                   });
                   Utils().toastMessage(e.toString());
              });
            })
          ],
        ),
      ),


    );


  }

}