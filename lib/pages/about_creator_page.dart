import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';
import '../widgets/texts.dart';

class AboutCreatorPage extends StatelessWidget {
  const AboutCreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: whiteColor,
          centerTitle: true,
          title: boldDefaultText('About Creator', TextAlign.center),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: lightGreyColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/kucing_teriak.jpeg'),
                      radius: 50,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Denisha Kyla Azzahra',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const Text('123210130'),
                    const SizedBox(height: 5),
                    _githubButton(context, 'denishazzahra'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _githubButton(BuildContext context, String username) {
    Uri url = Uri.parse('https://github.com/$username');
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () {
            _launchUrl(url);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/github.png',
                width: 18,
              ),
              const SizedBox(width: 10),
              const Text('Visit GitHub'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
