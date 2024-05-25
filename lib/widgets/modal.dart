import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../pages/about_creator_page.dart';
import '../pages/login_page.dart';
import '../pages/testimonial_page.dart';
import '../utils/token.dart';

class ModalFit extends StatefulWidget {
  const ModalFit({super.key});

  @override
  State<ModalFit> createState() => _ModalFitState();
}

class _ModalFitState extends State<ModalFit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 15),
          ListTile(
            title: const Text('Class Testimonial'),
            leading: const Icon(Symbols.campaign, fill: 0),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const TestimonialPage();
                }),
              );
            },
          ),
          ListTile(
            title: const Text('About Creator'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const AboutCreatorPage();
                }),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout_outlined),
            onTap: () {
              deleteToken();
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              ));
            },
          ),
          const SizedBox(height: 15),
        ],
      ),
    ));
  }
}
