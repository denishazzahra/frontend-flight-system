import 'package:shared_preferences/shared_preferences.dart';

Future<void> deleteToken() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.remove('token');
}
