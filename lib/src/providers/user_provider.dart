import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_user/preferencias_usuarios/preferences_users.dart';

class UserProvider{
   
  final String _firebaseToken = 'AIzaSyA71IHpevfelSbfWFVsQkDXPGAIdj-vvJI';
  final _preference = PreferencesUsers();


Future<Map<String,dynamic>>login(String email, String password) async{

      final authData = {
        'email'    : email,
        'password' : password,
        'returnSecureToken' : true
      };

      final resp = await http.post( Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken'),
      body: json.encode(authData)
      );

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      print(decodedResp);

      if(decodedResp.containsKey('idToken')){
        //Salvar el token en el storage

        _preference.token = decodedResp['idToken'];

        return {'ok':true, 'token': decodedResp['idToken']};
      }else{
        return {'ok':false, 'mensaje': decodedResp['error']['message']};
      }
  }


  Future<Map<String,dynamic>>nuevoUser(String email, String password) async{

      final authData = {
        'email'    : email,
        'password' : password,
        'returnSecureToken' : true
      };

      final resp = await http.post( Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'),
      body: json.encode(authData)
      );

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      print(decodedResp);

      if(decodedResp.containsKey('idToken')){
        //Salvar el token en el storage

         _preference.token = decodedResp['idToken'];

        return {'ok':true, 'token': decodedResp['idToken']};
      }else{
        return {'ok':false, 'mensaje': decodedResp['error']['message']};
      }
  }



}