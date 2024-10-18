import 'package:flutter/material.dart';

class InputTextFormField {
  //기본 입력창 데코
  InputDecoration basicFormDeco(hintText) {
    return InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
            )
        )
    );
  }
}