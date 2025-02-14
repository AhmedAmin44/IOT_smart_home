import 'package:flutter/material.dart%20%20';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_smart_home_secure/core/utils/app_colors.dart';


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