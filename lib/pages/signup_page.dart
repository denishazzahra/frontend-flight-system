import 'package:flutter/material.dart';
import '../connection/api_data_source.dart';
import '../model/login_model.dart';
import '../utils/colors.dart';
import '../widgets/buttons.dart';
import '../widgets/text_fields.dart';
import '../widgets/texts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool isRegisterSuccess = false;
  late Login loginInfo = Login();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  titleText('Sign Up', blackColor, TextAlign.left),
                  const SizedBox(height: 5),
                  subText('Create an account to continue.', TextAlign.left),
                  const SizedBox(height: 30),
                  textField(
                    controller: _fullNameController,
                    placeholder: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 15),
                  textField(
                    controller: _emailController,
                    placeholder: 'Email Address',
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                  const SizedBox(height: 15),
                  textField(
                    controller: _phoneController,
                    placeholder: 'Phone Number',
                    prefixIcon: const Icon(Icons.numbers_rounded),
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
                  const SizedBox(height: 15),
                  textField(
                    controller: _confirmPasswordController,
                    placeholder: 'Confirm Password',
                    isObscure: _obscureConfirmPassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        _obscureConfirmPassword
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
                      : blackButton(context, 'Sign Up', signUp),
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
        subText('Already have an account? ', TextAlign.start),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: boldDefaultText('Login', TextAlign.start),
        )
      ],
    );
  }

  bool validatePassword(String password) {
    // Minimum length of 8 characters
    if (password.length < 8) {
      return false;
    }
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return false;
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return false;
    }
    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return false;
    }
    // Check for at least one special character
    if (!RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) {
      return false;
    }
    // All checks passed, the password is strong
    return true;
  }

  bool validateFullName(String fullName) {
    // Minimum length of 4 and maximum of 50 characters
    if (fullName.length < 4 || fullName.length > 50) {
      return false;
    }
    // Check if the fullName has only alphabet or space
    if (!RegExp(r'^([a-zA-Z]+[\s]?)+$').hasMatch(fullName)) {
      return false;
    }
    // All checks passed, the fullName is valid
    return true;
  }

  bool validateEmail(String email) {
    if (!RegExp(r'^[\w-\.]+@(([\w-]+\.)+[\w-]{2,4})+$').hasMatch(email)) {
      return false;
    }
    return true;
  }

  bool validatePhone(String phone) {
    if (!RegExp(r'^\d{8,15}$').hasMatch(phone)) {
      return false;
    }
    return true;
  }

  void signUp() {
    setState(() {
      _isLoading = true;
    });
    String text = '';
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    if (!validateFullName(fullName)) {
      text =
          'Full name should be 4-50 alphabet characters or space, with no double space.';
      isRegisterSuccess = false;
    } else if (!validateEmail(email)) {
      text = 'Email is invalid.';
      isRegisterSuccess = false;
    } else if (!validatePhone(phone)) {
      text = 'Phone number should be 8-15 numerical character only.';
      isRegisterSuccess = false;
    } else if (!validatePassword(password)) {
      text =
          'Password should be at least 8 character consisted of uppercase, lowercase, number, and symbol.';
      isRegisterSuccess = false;
    } else if (password != confirmPassword) {
      text = 'Password is not identical!';
      isRegisterSuccess = false;
    } else {
      Map<String, String> body = {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'role': 'User'
      };
      ApiDataSource.signup(body).then((data) {
        setState(() {
          loginInfo = Login.fromJson(data);
          if (loginInfo.status == 'Success') {
            isRegisterSuccess = true;
            text = 'Sign up success!';
            Navigator.pop(context);
          } else {
            isRegisterSuccess = false;
            text = loginInfo.message!;
          }
          _isLoading = false;
          SnackBar snackbar = SnackBar(content: Text(text));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
          isRegisterSuccess = false;
          text = 'An error occurred: $error';
          SnackBar snackbar = SnackBar(content: Text(text));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        });
      });
    }
    if (!_isLoading) {
      SnackBar snackbar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
