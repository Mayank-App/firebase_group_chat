import 'package:firebase/ui/auth/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../round_button.dart';

class VerifyCode extends StatefulWidget{
 final String verification ;

 VerifyCode({
   required this.verification
});
  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  @override
  var loading = false;
  final controller = TextEditingController();
  final _auth =   FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
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
                  hintText: "6 digit code"
              ),
            ),
            SizedBox(height: 50,),
            RoundButton(title: "Verify",
                loading: loading,
              onTap:() async {
              setState(() {
                loading=true;
              });
           final credential = PhoneAuthProvider.credential(
               verificationId: widget.verification,
               smsCode: controller.text.toString());
           try{
            await _auth.signInWithCredential(credential);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
           }
           catch(e)  {
             setState(() {
               loading = false;

             });
             Utils().toastMessage(e.toString());
           }
              } ,
            )
          ],
        ),
      ),


    );


  }

}