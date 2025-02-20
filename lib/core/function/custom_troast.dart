import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';


 // ignore: non_constant_identifier_names
 ShowToast(String errmsg){
  Fluttertoast.showToast(
      msg: errmsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.deepGrey,
      textColor: Colors.white,
      fontSize: 16.0,
      );
}