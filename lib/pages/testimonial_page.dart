import 'package:flutter/material.dart';
import 'package:tugas5_tpm/utils/colors.dart';
import 'package:tugas5_tpm/widgets/testimonial_dropdown.dart';
import 'package:tugas5_tpm/widgets/texts.dart';

class TestimonialPage extends StatelessWidget {
  const TestimonialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: whiteColor,
          centerTitle: true,
          title: boldDefaultText('Testimonial', TextAlign.center),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const TestimonialDropdown(),
          ),
        ),
      ),
    );
  }
}
