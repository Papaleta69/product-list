import 'dart:io';
import 'package:login_user/src/models/product_model.dart';
import 'package:login_user/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {


   final _productsController = BehaviorSubject<List<ProductoModel>>();
   final _loadingController = BehaviorSubject<bool>();

   final _productsProviders = ProductosProvider();

  Stream<List<ProductoModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

   
   void loadingProducts() async{

     final products = await _productsProviders.cargarProductos();

     _productsController.sink.add(products);
   }

   void addProducts(ProductoModel productAdd) async{
     _loadingController.sink.add(true);
     await _productsProviders.crearProducto(productAdd);
     _loadingController.sink.add(false);
   }

   Future<String>uploadPhoto(File foto) async{
     _loadingController.sink.add(true);
     final fotoUrl = await _productsProviders.subirImagen(foto);
     _loadingController.sink.add(false);

     return fotoUrl;
   }

   void editProducts(ProductoModel productEdit) async{
     _loadingController.sink.add(true);
     await _productsProviders.editarProducto(productEdit);
     _loadingController.sink.add(false);
   }

   void deleteProducts(String idProduct) async{
     await _productsProviders.borrarProducto(idProduct);
  
   }


   dispose(){
     _productsController.close();
     _loadingController.close();
   }


 }