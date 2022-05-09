import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:login_user/preferencias_usuarios/preferences_users.dart';
import 'dart:convert';
import 'package:login_user/src/models/product_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider{

  final String _url = 'https://flutter-varios-e6fa9-default-rtdb.firebaseio.com';
  final _preferencesUser = PreferencesUsers();

  Future<bool>crearProducto(ProductoModel producto) async {
   
   final url = '$_url/productos.json?auth=${_preferencesUser.token}';

   final resp = await http.post(Uri.parse(url), body: productoModelToJson(producto));
   
   final decodeData = json.decode(resp.body);

   print(decodeData);

   return true;
  }

  Future<bool>editarProducto(ProductoModel producto) async {
   
   final url = '$_url/productos/${producto.id}.json?auth=${_preferencesUser.token}';

   final resp = await http.put(Uri.parse(url), body: productoModelToJson(producto));
   
   final decodeData = json.decode(resp.body);

   print(decodeData);

   return true;
  }

  Future<List<ProductoModel>>cargarProductos()async{

    final url = '$_url/productos.json?auth=${_preferencesUser.token}';

    final resp = await http.get(Uri.parse(url));

    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductoModel> productos = [];

   if (decodeData == null) return [];

   if(decodeData['error'] != null) return[];

   decodeData.forEach((id, product) { 
    
    final prodTemp = ProductoModel.fromJson(product);
    prodTemp.id = id;
    
    productos.add(prodTemp);

   });

   return productos;
  }

  Future<int>borrarProducto(String id)async{

   final url = '$_url/productos/$id.json?auth=${_preferencesUser.token}';
   
   final resp = await http.delete(Uri.parse(url));

   print(json.decode(resp.body));

   return 1;

  }

  Future<String> subirImagen(File imagen)async{

       final url = Uri.parse('https://api.cloudinary.com/v1_1/dy5m9j4db/image/upload?upload_preset=lvieppyr');

       final mimeType = mime(imagen.path)!.split('/');//tipo de imagen

       final imageUploadRequest = http.MultipartRequest(
         'POST',
          url
       );

       final file = await http.MultipartFile.fromPath(
         'file',
         imagen.path,
         contentType: MediaType(mimeType[0], mimeType[1])
       );

       imageUploadRequest.files.add(file);

       final streamResponse = await imageUploadRequest.send();
       final resp = await http.Response.fromStream(streamResponse);

       if(resp.statusCode != 200 && resp.statusCode != 201){
         print('Error');
         print(resp.body);

         //return null;
       }

       final resData = json.decode(resp.body);
       print(resData);

       return resData['secure_url'];
  }
}