import 'package:flutter/material.dart';

class TextfieldCustom extends StatelessWidget {
  final TextEditingController myController;
  final String? hintText;
  final bool? isPassword;
  const TextfieldCustom({super.key, required this.myController, this.hintText, this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType:  isPassword! 
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
        enableSuggestions: isPassword!? false:true,
        autocorrect: isPassword ?? true,
        obscureText: isPassword??true,
        controller: myController,
        decoration: InputDecoration(
          suffixIcon: isPassword! ? IconButton(
            onPressed: () {},
            icon: const Icon(Icons.visibility_outlined, color: Colors.black,),
          )
          : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10)
          ),
          fillColor: Color(0xffE8ECF4),
          filled: true,
          hintText: hintText,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10),
          // ),
          isDense: true,
        ),
      ),
    );
  }
}