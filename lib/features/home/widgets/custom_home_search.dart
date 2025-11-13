import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({super.key, this.onChanged});

  final void Function(String)? onChanged;

  @override
  State<SearchHome> createState() => _SearchHomeState();
}

class _SearchHomeState extends State<SearchHome> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: TextFormField(
        onChanged: widget.onChanged,
        controller: controller,
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
