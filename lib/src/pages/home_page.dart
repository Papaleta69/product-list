
import 'package:flutter/material.dart';
import 'package:login_user/src/bloc/products_bloc.dart';
import 'package:login_user/src/bloc/provider.dart';
import 'package:login_user/src/models/product_model.dart';


class HomePage extends StatelessWidget {
  
  //final productosProvider = ProductosProvider();

 
  
  @override
  Widget build(BuildContext context) {
    
    final productosBloc = Provider.productBloc(context);
    productosBloc.loadingProducts();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      /*body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Email: ${bloc.email}'),
            const Divider(),
            Text('Password: ${bloc.password}')
          ],
        ),*/

      body: _creatrListado(productosBloc),

      floatingActionButton: _crearButton(context),
    );
  }

  Widget _creatrListado(ProductsBloc listProducts) {

     // Método de llamado mediante Patron Bloc
     return StreamBuilder(
       stream: listProducts.productsStream,
       builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
         if(snapshot.hasData){
             final productos = snapshot.data;
             return ListView.builder(
                 itemCount: productos!.length,
                 itemBuilder: (context, i) => _crearItem(context, listProducts, productos[i])

             );
           }else{
             return const Center(child: CircularProgressIndicator());
           }
       },
     );
     
     // Método de llamado normal
     /*return FutureBuilder(
       future: productosProvider.cargarProductos(),
       builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
           
           if(snapshot.hasData){
             final productos = snapshot.data;
             return ListView.builder(
                 itemCount: productos!.length,
                 itemBuilder: (context, i) => _crearItem(context,productos[i])

             );
           }else{
             return const Center(child: CircularProgressIndicator());
           }
       },
     );*/
  }

  Widget _crearItem(BuildContext context, ProductsBloc listProducts, ProductoModel producto){

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion){
        //productosProvider.borrarProducto(producto.id!);
        listProducts.deleteProducts(producto.id!);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null) 
              ? const Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                image: NetworkImage(producto.fotoUrl!),
                placeholder: const AssetImage('assets/jar-loading.gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
               ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id!),
                onTap: ()=> Navigator.pushNamed(context, 'product', arguments: producto),
            )
          ],
        ),
      )

      );
      
  }

  _crearButton(BuildContext context) {

    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=> Navigator.pushNamed(context, 'product'),
    );
  }

  
}