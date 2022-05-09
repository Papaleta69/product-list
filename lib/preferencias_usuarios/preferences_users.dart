import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUsers{
  

  static final PreferencesUsers _instance = PreferencesUsers._internal();
  
  factory PreferencesUsers(){
    return _instance;
  }

  PreferencesUsers._internal();

  late SharedPreferences prefs;
  
  initPrefs()async{
   prefs = await SharedPreferences.getInstance();
   

  }

  // GET y SET del nombre
  String get token {
    return prefs.getString('token') ?? '';
  }

  set token( String value ) {
    prefs.setString('token', value);
  }
  

  // GET y SET de la última página
  String get ultimaPagina {
    return prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    prefs.setString('ultimaPagina', value);
  }
  
}