import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInKey = "ISLOGGEDIN";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool> saveuserloggedinsharepreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveusernamesharepreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userNameKey, userName);
  }

  static Future<bool> saveuseremailsharepreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, userEmail);
  }


  static Future<bool?> getuserloggedinsharepreference(
      ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return  preferences.getBool(userLoggedInKey);
  }

  static Future getusernamesharepreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(userNameKey);
  }

  static Future getuseremailsharepreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(userEmailKey);
  }
}
