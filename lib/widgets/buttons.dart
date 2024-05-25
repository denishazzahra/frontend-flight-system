import '../utils/colors.dart';
import 'package:flutter/material.dart';

Widget blackButton(BuildContext context, String text, Function function) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: blackColor,
        foregroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(15),
      ),
      child: Text(text),
    ),
  );
}
