import 'package:flutter/material.dart';
class Mybutton{
  myOutLinedButton(fun, text){
    return OutlinedButton(
      onPressed: fun,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
        )
      ),
      child: Text(text),
    );
  }

  myTextButton(fun, text){
    return TextButton(
      onPressed: fun,
      style: OutlinedButton.styleFrom(
          minimumSize: Size.zero,

          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))
          )
      ),
      child: Text(text),
    );
  }
}