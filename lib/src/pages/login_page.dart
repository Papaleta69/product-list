import 'package:flutter/material.dart';
import 'package:login_user/src/bloc/login_bloc.dart';
import 'package:login_user/src/bloc/provider.dart';
import 'package:login_user/src/providers/user_provider.dart';
import 'package:login_user/src/utils/utils.dart';


class LoginPage extends StatelessWidget {
 
 final usuarioProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
      
    );
  }

 Widget _crearFondo(BuildContext context) {

   final size = MediaQuery.of(context).size;

   final fondoMorado = Container(
     height: size.height * 0.4,
     width: double.infinity,
     decoration: const BoxDecoration(
       gradient: LinearGradient(
         colors: <Color>[
           Color.fromRGBO(63, 63, 156, 1.0),
           Color.fromRGBO(90, 70, 178, 1.0),
         ]
       )
     ),
   );

   final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: const Color.fromRGBO(255, 255, 255, 0.05),
    ),

   );

   return Stack(
     children: <Widget>[
       fondoMorado,
       Positioned(top: 90.0,left: 30.0,child: circulo),
       Positioned(top: -40.0,right: -30.0,child: circulo),
       Positioned(bottom: -50.0,right: -10.0,child: circulo),
       Positioned(bottom: 120.0,right: 20.0,child: circulo),
       Positioned(bottom: -50.0,left: -20.0,child: circulo),

       Container(
         padding: const EdgeInsets.only(top: 80.0),
         child: Column(
           children: const <Widget>[
             Icon(Icons.person_pin_circle, color:Colors.white, size: 100.0),
             SizedBox(height: 10.0, width: double.infinity),
             //Text('Neyer Gutierrez Torres', style: TextStyle(color: Colors.white, fontSize: 25.0))
           ],
         ),
       ),
     ],
   );
 }

 Widget _loginForm(BuildContext context) {
   
   final bloc = Provider.of(context);
   final size = MediaQuery.of(context).size;
   
   return SingleChildScrollView(
     child: Column(
       children: <Widget>[
         SafeArea(
           child: Container(
             height: 220.0,
           ),
         ),
         Container(
           width: size.width * 0.85,
           margin: const EdgeInsets.symmetric(vertical: 30.0),
           padding: const EdgeInsets.symmetric(vertical: 50.0),
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(5.0),
             boxShadow: const <BoxShadow>[
               BoxShadow(
                 color: Colors.black26,
                 blurRadius: 3.0,
                 offset: Offset(0.0, 5.0),
                 spreadRadius: 3.0,
               )
             ]
           ),


           child: Column(
             children: <Widget>[
               const Text('Iniciar sesión', style: TextStyle(fontSize: 20.0)),
               const SizedBox(height: 60.0),
               _crearEmail(bloc),
               const SizedBox(height: 30.0),
               _crearPassword(bloc),
               const SizedBox(height: 30.0),
               _botonIngresar(bloc),
             ],
           ),
         ),
         FlatButton(
           child: const Text('Crear una cuenta'),
           onPressed: () => Navigator.pushReplacementNamed(context, 'registro'),
         ),
         const SizedBox(height: 100.0),
       ],
     ),
   );
 }

 Widget _crearEmail(LoginBloc bloc) {
  
  return StreamBuilder(
    stream: bloc.emailStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
     padding: const EdgeInsets.symmetric(horizontal: 20.0),
     child: TextField(
       keyboardType: TextInputType.emailAddress,
       decoration: InputDecoration(
         icon: const Icon(Icons.alternate_email, color: Colors.deepPurple),
         hintText: 'ejemplo@correo.com',
         labelText: 'Correo Electrónico',
         counterText: snapshot.data,
         errorText: snapshot.error?.toString(), 
       ),
       onChanged: (value) => bloc.changeEmail(value),
     ),
    );
   },
  );
  
 }

 Widget _crearPassword(LoginBloc bloc) {
   
   //Método de llamado mediante Patron Bloc
   return StreamBuilder(
     stream: bloc.passwordStream,
     builder: (BuildContext context, AsyncSnapshot snapshot) {

   return Container(
     padding: const EdgeInsets.symmetric(horizontal: 20.0),
     child: TextField(
       obscureText: true,
       decoration: InputDecoration(
         icon: const Icon(Icons.lock_outline, color: Colors.deepPurple),
         labelText: 'Contraseña',
         counterText: snapshot.data,
         errorText: snapshot.error?.toString(), 
       ), 
       onChanged: (value) => bloc.changePassword(value),
     ),
    );
   },
   );
 }

 Widget _botonIngresar(LoginBloc bloc) {

   return StreamBuilder(
     stream: bloc.validationStream,
     builder: (BuildContext context, AsyncSnapshot snapshot) {
       
    return RaisedButton(
       child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: const Text('Ingresar'),
       ),
       
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(5.0),
      
      ),

      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
       onPressed: snapshot.hasData? () => _login(bloc, context) : null
     );
    },
   );
  }

  _login(LoginBloc bloc, BuildContext context) async{

    Map information = await usuarioProvider.login(bloc.email, bloc.password);

    if(information['ok']){
      Navigator.pushReplacementNamed(context, 'home');
    }else{
      mostrarAlerta(context, information['mensaje']);
    }
    
  }
}
