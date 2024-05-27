import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas5_tpm/connection/api_data_source.dart';
import 'package:tugas5_tpm/pages/home_page.dart';
import 'package:tugas5_tpm/utils/colors.dart';
import 'package:tugas5_tpm/widgets/buttons.dart';

import '../model/updated_user_model.dart';
import '../model/user_model.dart';
import '../widgets/text_fields.dart';
import '../widgets/texts.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late String token;
  late UpdatedUserModel httpResponse;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _fullNameController.text = widget.user.fullName ?? '';
    _emailController.text = widget.user.email ?? '';
    _phoneController.text = widget.user.phone ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: whiteColor,
          centerTitle: true,
          title: boldDefaultText('Edit Profile', TextAlign.center),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: widget.user.profilePicture != null
                            ? NetworkImage(widget.user.profilePicture!)
                            : const AssetImage('assets/images/default_pic.png')
                                as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('This is an upcoming feature (:'),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: blackColor,
                            child: Icon(
                              Symbols.edit,
                              fill: 1,
                              size: 15,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  textFieldWithLabel(
                    controller: _fullNameController,
                    placeholder: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 15),
                  textFieldWithLabel(
                    controller: _emailController,
                    placeholder: 'Email Address',
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                  const SizedBox(height: 15),
                  textFieldWithLabel(
                    controller: _phoneController,
                    placeholder: 'Phone Number',
                    prefixIcon: const Icon(Icons.numbers_rounded),
                  ),
                  const SizedBox(height: 30),
                  blackButton(context, 'Save Changes', _updateProfile),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateProfile() {
    final email = _emailController.text;
    final fullName = _fullNameController.text;
    final phone = _phoneController.text;
    Map<String, dynamic> body = {
      "fullName": fullName,
      "email": email,
      "phone": phone,
    };
    ApiDataSource.editProfile(token, body).then((data) {
      httpResponse = UpdatedUserModel.fromJson(data);
      if (httpResponse.status == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated user account!')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return const HomePage(index: 3);
          }),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    });
  }

  void _loadToken() {
    SharedPreferences.getInstance().then((storage) {
      setState(() {
        token = storage.getString('token')!;
      });
    });
  }
}
