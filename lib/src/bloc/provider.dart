import 'package:flutter/material.dart';
import 'package:login_user/src/bloc/login_bloc.dart';
import 'package:login_user/src/bloc/products_bloc.dart';


class Provider extends InheritedWidget{

  final loginBloc = LoginBloc();
  final productsBloc = ProductsBloc();

  static Provider? _instancia;

  factory Provider({Key? key, required Widget child}){ 
     if(_instancia==null){
       return _instancia = Provider._internal(key: key, child: child);
     }

     return _instancia!;
    
  }

   Provider._internal({Key? key, required Widget child}) 
     : super(key: key, child: child);

  /*Provider({Key? key, required Widget child}) 
     : super(key: key, child: child);*/

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
  
  static LoginBloc of (BuildContext context){
    
    return(context.dependOnInheritedWidgetOfExactType<Provider>() as Provider).loginBloc;

  }

  static ProductsBloc productBloc (BuildContext context){
    
    return(context.dependOnInheritedWidgetOfExactType<Provider>() as Provider).productsBloc;

  }

}