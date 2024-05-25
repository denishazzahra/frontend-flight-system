import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../utils/colors.dart';
import 'package:flutter/material.dart';

import 'modal.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Image.asset(
        'assets/images/flight.png',
        height: double.infinity,
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {
          showBarModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const ModalFit(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(
            Icons.menu,
            color: blackColor,
          ),
        ),
      ),
    ],
  );
}
