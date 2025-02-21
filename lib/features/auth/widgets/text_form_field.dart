import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart%20%20';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_text_style.dart';

class TextFField extends StatelessWidget {
  const TextFField({Key? key, required this.labelText, this.onChanged, this.onFieldSubmitted,this.suffixIcon, this.obscureText,}) : super(key: key);
  final String labelText;
  final Function (String)? onChanged;
  final Function (String)? onFieldSubmitted;
  final bool? obscureText;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top:24 ,right: 8,left: 8),
      child: TextFormField(
        validator: (value) {
          if(value!.isEmpty){
            return "This Field is requierd";
          }else{return null;}
        },
        onChanged:onChanged ,
        onFieldSubmitted:onFieldSubmitted ,
        obscureText: obscureText ?? false,
        style: TextStyle(color: AppColors.lightGrey),
        decoration: InputDecoration(
          suffixIcon:suffixIcon ,
          suffixIconColor: AppColors.offWhite,
          labelText: labelText,
          labelStyle: CustomTextStyles.poppins500style17.copyWith(color: Colors.white),
          border: getBordrStyle(),
          enabledBorder: getBordrStyle(),
          focusedBorder: getBordrStyle(),

        ),
      ),
    );
  }
}

OutlineInputBorder getBordrStyle(){
  return  OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: AppColors.prColor)
  );
}
