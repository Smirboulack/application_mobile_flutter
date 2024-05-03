import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class TextFieldWidget extends StatelessWidget {
  var onChanged;

  TextFieldWidget(
      this.name, this.focus, this.myController, this.type, this.validator,
      {super.key,
      this.obscure = false,
      this.prefixWidget,
      required this.nameF,
      this.submit,
      this.suffixIcon,
      this.maxLines = 1,
      this.onChanged});

  String name;
  FocusNode focus;
  final prefixWidget;
  TextEditingController myController = TextEditingController();
  var validator;
  String? suffixIcon;
  var type;
  bool obscure;
  int maxLines = 1;
  String nameF;

  var submit;

  @override
  Widget build(BuildContext context) {
    Widget textfield = FormBuilderTextField(
      style: new TextStyle(fontSize: 16.0.sp, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      focusNode: focus,
      maxLines: maxLines,
      decoration: InputDecoration(
          suffixIcon: prefixWidget ?? const SizedBox(width: 1, height: 1),
          prefixIcon: suffixIcon == null
              ? null
              : Container(
                  padding: EdgeInsets.only(
                    top: 12.w,
                    bottom: 12.w,
                  ),
                  child: SvgPicture.asset(suffixIcon!,
                      color: ColorsConst.col_app, width: 12.w, height: 8.h)),
          contentPadding: EdgeInsets.all(16.0.w),
          fillColor: ColorsConst.backTextfieldColor2,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: const BorderSide(
                width: 1, color: ColorsConst.backTextfieldColor2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide:
                BorderSide(width: 1, color: ColorsConst.backTextfieldColor2),
          ),
          hintText: name,
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: ColorsConst.colhint2,
          )),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: type,
      validator: validator,
      onChanged: onChanged,
      name: nameF,
      /* onSaved: (val) {
        myController.text = val;
        submit();
      },
      onFieldSubmitted: (val) {
        myController.text = val;
        submit();
      },*/
    );

    return textfield;
  }
}
