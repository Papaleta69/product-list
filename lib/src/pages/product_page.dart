import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_user/src/bloc/products_bloc.dart';
import 'package:login_user/src/bloc/provider.dart';
import 'package:login_user/src/utils/utils.dart' as utils;
import 'package:login_user/src/models/product_model.dart';


class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<  ScaffoldState>();
  //final productoProvider = ProductosProvider();
  
  ProductsBloc? productosBloc;
  ProductoModel producto = ProductoModel();
  bool _guardando = false;

  File? guardarImage;
  

 
  @override
  Widget build(BuildContext context) {
  
  productosBloc = Provider.productBloc(context);
  
  //final productData = ModalRoute.of(context)!.settings.arguments as ProductoModel;
  final productData = ModalRoute.of(context)?.settings.arguments as ProductoModel?;
 

    if(productData != null){
       producto = productData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo_size_select_actual),
            onPressed: () => _seleccionarFoto(),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed:() =>_tomarFoto(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _crearNombre() {
  
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value){
           if(value!.length<3){
             return 'Ingrese el producto';
           }else{
             return null;
           }
      },
    );
  }

 Widget _crearPrecio() {

   return TextFormField(
     initialValue: producto.valor.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal:true),
      decoration: const InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.valor = double.parse(value.toString()),
      validator: (value){
         
         if(utils.isNumeric(value.toString())){
              return null;
         }else{
           return 'Solo números';
         }
      },
    );

  }

  Widget _crearDisponible() {
    
    return SwitchListTile(
      value: producto.disponible!,
      title: const Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

 Widget _crearBoton() {

   return RaisedButton.icon(
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(20.0)
     ),
     color: Colors.deepPurple,
     textColor: Colors.white,
     label: const Text('Guardar'),
     icon: const Icon(Icons.save),
     onPressed: (_guardando)? null: _submit,
     //onPressed: _submit,
   );
 }

  void _submit() async{
     if (!formKey.currentState!.validate()) return;

     formKey.currentState!.save();
     
     setState(() {_guardando = true;});

     if(guardarImage != null){
       //producto.fotoUrl = await productoProvider.subirImagen(guardarImage!);
         producto.fotoUrl = await productosBloc!.uploadPhoto(guardarImage!);
     }

     if(producto.id==null){
       //productoProvider.crearProducto(producto);
       productosBloc!.addProducts(producto);
     }else{
       //productoProvider.editarProducto(producto);
       productosBloc!.editProducts(producto);
     }
     //setState(() {_guardando = false;});
     mostrarSnackbar('Registro guardado');

     Navigator.pop(context);
     
  }

  void mostrarSnackbar(String mensaje){

    final snackbar = SnackBar(
      
      content: Text(mensaje),
      duration: const Duration(milliseconds:1500),
    );

    scaffoldKey.currentState!.showSnackBar(snackbar);
   
  }

  Widget _mostrarFoto(){
    
    if(producto.fotoUrl != null){
      return Container(
        height: 300.0,
        child: FadeInImage(
          image: NetworkImage(producto.fotoUrl!),
          placeholder: const AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.contain,
        ),
      );
    }else{

        return Container(
                height: 300.0,
                child: guardarImage != null
                    ? Image.file(guardarImage!, fit: BoxFit.cover, height: 300.0)
                    : const Image(image: AssetImage('assets/no-image.png')),
      );

      /*return Image(
        image: AssetImage(guardarImage?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );*/

     
    }
  }

  _seleccionarFoto() async{
    
    _procesarImagen(ImageSource.gallery);
    
  }

  _tomarFoto() async{

   _procesarImagen(ImageSource.camera);
    
  }

  _procesarImagen(ImageSource origen) async{
   
   final ImagePicker _picker = ImagePicker();

    final XFile? seleccionarFoto = await _picker.pickImage(source: origen);

    if(seleccionarFoto != null){
      producto.fotoUrl = null; 
    }

    setState(() {
      guardarImage = File(seleccionarFoto!.path);
    });

  }

}