import 'package:dailyapp/db/DbHelper.dart';
import 'package:flutter/material.dart';
class Mybutton{
  DBHelper db = DBHelper();
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

  MySearchButton(fun, String text){
    return OutlinedButton(
        onPressed: fun,
        style: OutlinedButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))
            )
        ),
        child: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              IconButton(
                  onPressed: (){
                    db.deleteSearch(text);
                    },
                  icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  minimumSize: Size.zero,
                ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero
              )
            ],
          ),
        ),
    );
  }
}