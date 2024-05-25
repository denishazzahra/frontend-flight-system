import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas5_tpm/connection/api_data_source.dart';
import 'package:tugas5_tpm/widgets/buttons.dart';

import '../model/login_model.dart';
import '../utils/colors.dart';
import '../widgets/text_fields.dart';
import '../widgets/texts.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailPhoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late Login loginInfo = Login();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  titleText('Login', blackColor, TextAlign.left),
                  const SizedBox(height: 5),
                  subText(
                      'Welcome back, glad to see you again!', TextAlign.left),
                  const SizedBox(height: 30),
                  textField(
                    controller: _emailPhoneController,
                    placeholder: 'Email/Phone',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 15),
                  textField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    isObscure: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: greyTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: blackColor))
                      : blackButton(context, 'Login', login),
                  const SizedBox(height: 15),
                  _signupButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        subText('Don\'t have an account? ', TextAlign.start),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpPage(),
              ),
            );
          },
          child: boldDefaultText('Sign Up', TextAlign.start),
        )
      ],
    );
  }

  void login() {
    setState(() {
      _isLoading = true;
    });

    String emailOrPhone = _emailPhoneController.text.trim();
    String password = _passwordController.text;
    Map<String, String> body = {
      'emailOrPhone': emailOrPhone,
      'password': password,
    };
    ApiDataSource.login(body).then((data) {
      setState(() {
        _isLoading = false;
        loginInfo = Login.fromJson(data);
        if (loginInfo.status == 'Success') {
          setToken(loginInfo.token!).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Success!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage(index: 0)),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${loginInfo.message}')),
          );
        }
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')),
        );
      });
    });
  }

  Future<void> setToken(String token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', token);
  }
}
