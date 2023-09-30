import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final   VoidCallback onTap;
  final String title;
  final bool loading;

  RoundButton(
  {
   required this.onTap,
    required this.title,
    this.loading = false
}
      );
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap : onTap,
     child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: loading ? CircularProgressIndicator(color: Colors.white,strokeWidth: 3,) : Text(title,style: TextStyle(fontSize: 22,color: Colors.white),),

        ),
      ),
    );
  }
}