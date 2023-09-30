import 'package:firebase/ui/auth/goggle_services/verify_goggle.dart';
import 'package:firebase/ui/auth/login_with_phoneNumber.dart';
import 'package:firebase/ui/auth/posts/post_screen.dart';
import 'package:firebase/ui/auth/signup_screen.dart';
import 'package:firebase/ui/forget_password.dart';
import 'package:firebase/ui/round_button.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey =GlobalKey<FormState>();
  bool loading =false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
      final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void login(){
    _auth.signInWithEmailAndPassword(email: email.text.toString(),
        password: password.text.toString()).then((value){
          Utils().toastMessage(value.user!.email.toString());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PostScreen()));
          setState(() {
            loading=false;
          });
    }).onError((error, stackTrace){
       setState(() {
         loading=false;
       });
      Utils().toastMessage(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: ()async{
       SystemNavigator.pop();
       return true;
     },
     child: Scaffold(
       appBar: AppBar(
         automaticallyImplyLeading: false,
         title: Text("Login"),
         backgroundColor: Colors.purple,
       ),
       body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Form(
               key: _formKey,
                 child: Column(
                   children: [
                     TextFormField(
                       keyboardType: TextInputType.emailAddress,
                       controller: email,
                       decoration: const InputDecoration(
                         prefixIcon: Icon(Icons.email),
                         hintText: 'Email',
                       ),
                       validator: (value){
                         if(value!.isEmpty){
                           return'Enter email';
                         }
                         else if (!(value.contains("@"))){
                           return " @ should be used";
                         }
                         else{
                           return null;
                         }
                       },
                     ),
                     SizedBox(height: 10,),
                     TextFormField(
                       keyboardType: TextInputType.text ,
                       controller: password,
                       obscureText: true,
                       decoration: const InputDecoration(
                         prefixIcon: Icon(Icons.password_sharp),
                         hintText: 'Password',
                       ),
                       validator: (value){
                         if(value!.isEmpty){
                           return'Enter password';
                         }
                         else if( value.length <6 ){
                           return " Enter atleast 6 digit password";
                         }
                         else{
                           return null;
                         }
                       },
                     ),
                   ],
                 )),
             SizedBox(height: 50,),
             RoundButton(title: "Login",
                 loading: loading,
                 onTap: (){
               if(_formKey.currentState!.validate()){
                 setState(() {
                   loading=true;
                 });
                 login();
               }
             }),
             SizedBox(height: 10,),
             Align(
               alignment: Alignment.topRight,
               child: TextButton(onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));
               },
                   child: Text('Forgot Password?',style: TextStyle(color: Colors.purple.shade900),)
               ),
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Don't have an account?"),
                 TextButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                 },
                     child: Text('Sign Up')
                 )
               ],
             ),
             SizedBox(height: 20,),
             InkWell(
               onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhone()));
               },
               child: Container(height: 50,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   border: Border.all(color: Colors.black)
                 ),
                 child: Center(child: Text("Login with phone",style: TextStyle(fontSize:20),)),


               ),
             ),
             SizedBox(height: 20),
             InkWell(
               onTap: (){
                VerifyGoggle().signInWithGoogle();
               },
               child: Container(height: 50,
                 width: double.infinity,
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     border: Border.all(color: Colors.black)
                 ),
                 child: Center(child: Text("Login with goggle",style: TextStyle(fontSize:20),)),


               ),
             ),
             SizedBox(height: 20),
             InkWell(
               onTap: (){
                 VerifyGoggle().signInWithGoogle();
               },
               child: Container(height: 50,
                 width: double.infinity,
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     border: Border.all(color: Colors.black)
                 ),
                 child: Center(child: Text("Login with Facebook",style: TextStyle(fontSize:20),)),


               ),
             ),


           ],
         ),
       ),

     ),
   );
  }
}