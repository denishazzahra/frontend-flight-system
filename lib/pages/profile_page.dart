import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas5_tpm/connection/api_data_source.dart';
import 'package:tugas5_tpm/pages/edit_profile_page.dart';
import 'package:tugas5_tpm/utils/colors.dart';
import 'package:tugas5_tpm/widgets/buttons.dart';

import '../model/user_model.dart';
import '../widgets/texts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String token;
  late User user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return profileDisplay();
  }

  Widget profileDisplay() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: blackColor),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.profilePicture != null
                      ? NetworkImage(user.profilePicture!)
                      : const AssetImage('assets/images/default_pic.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              smallerSubText('Full Name', TextAlign.left),
                              boldDefaultText(
                                user.fullName!,
                                TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              smallerSubText('Email', TextAlign.left),
                              boldDefaultText(
                                user.email!,
                                TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              smallerSubText('Phone', TextAlign.left),
                              boldDefaultText(
                                user.phone!,
                                TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                blackButton(context, 'Edit Profile', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return EditProfilePage(user: user);
                    }),
                  );
                })
              ],
            ),
          ),
        ),
      );
    }
  }

  void _loadUser() {
    ApiDataSource.getUser(token).then((data) {
      user = UserModel.fromJson(data).user!;
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _loadToken() {
    SharedPreferences.getInstance().then((storage) {
      token = storage.getString('token')!;
    }).whenComplete(() {
      _loadUser();
    });
  }
}
