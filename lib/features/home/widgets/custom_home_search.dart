import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchHome extends StatelessWidget {
  const SearchHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        cursorHeight: 17,
        decoration: InputDecoration(
          prefixIcon: Icon(CupertinoIcons.search, color: Colors.black),
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
