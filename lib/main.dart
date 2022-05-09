import 'package:flutter/material.dart';
import 'package:login_user/preferencias_usuarios/preferences_users.dart';
import 'package:login_user/src/bloc/provider.dart';
import 'package:login_user/src/pages/home_page.dart';
import 'package:login_user/src/pages/login_page.dart';
import 'package:login_user/src/pages/product_page.dart';
import 'package:login_user/src/pages/registro_page.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferencesUsers();
  await prefs.initPrefs();
  runApp(MyApp()); 
  }

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
       title: 'Material App',
       initialRoute: 'login',
       //initialRoute: 'home',
       routes: {
         'login' : (BuildContext context) => LoginPage(),
         'home'  : (BuildContext context) => HomePage(),
         'product'  : (BuildContext context) => const ProductPage(),
         'registro'  : (BuildContext context) => RegistroPage()
      },  
      theme: ThemeData(
        primaryColor: Colors.deepPurple 
      ),
     )
    );  
  }
}