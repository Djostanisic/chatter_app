import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static String userLoggedInKey = "USER_LOGGED_IN_KEY";
  static String userNameKey = "USER_NAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userLoggedInKey);
  }

}