import 'package:flutter/material.dart';

class CustomToolbar extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const CustomToolbar({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            splashRadius: 20,
            onPressed: onPressed,
            icon:const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black,
            ),
          ),
          Expanded(child: Container()),
          Text(
            title,
            style:const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
