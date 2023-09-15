import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/round_button.dart';
import 'package:firebase/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget{
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey =GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp(){
    if(_formKey.currentState!.validate()){
      setState(() {
        loading=true;
      });
      _auth.createUserWithEmailAndPassword(
          email: email.text.toString() ,
          password: password.text.toString()
      ).then((value){
        setState(() {
          loading = false;
        });
      }
      ).onError((error, stackTrace){
        Utils().toastMessage(error.toString());
        setState(() {
          loading=false;
        });
      });

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Sign up"),
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
            RoundButton(title: "Sign up ",
                loading: loading,
                onTap: (){
             signUp();
            }),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      },
                    child: Text('Login')
                )
              ],
            )

          ],
        ),
      ),

    );
  }
}