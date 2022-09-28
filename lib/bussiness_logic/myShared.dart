import 'package:shared_preferences/shared_preferences.dart';

class MyShared{
  static late SharedPreferences sharedPreferences;

  static Future<void> init ()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }
  static void putBoolean(
  {
    required String key,
    required bool value
  }
      )async{
await sharedPreferences.setBool(key, value);
  }
  static bool getBoolean(key){
    return sharedPreferences.getBool(key)??false;
  }
  static void putString(
  {
  required String key,
  required String value
  }
      )async{
    await sharedPreferences.setString(key, value);
  }


static String getString(key){
  return sharedPreferences.getString(key)??'';
}
}