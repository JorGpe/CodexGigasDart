import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ConstrainedBox(
        constraints: const BoxConstraints(
              minHeight: 450,
            ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Image.asset(
                'lib/assets/404.jpg',
                //fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height *.4,
                width: MediaQuery.of(context).size.width*.4,
              ),
              
              const SizedBox(height: 20,),
        
              const Text('¡Oops! Parece que la pagina que buscas,\n no esta disponible' ), 
        
              const SizedBox(height: 20,),
              
              TextButton(onPressed: (){
                try{
                  context.pop();
                }catch(error){
                  //It's ok no to do anything
                }
        
                Future.delayed(const Duration(milliseconds: 100), () => context.go("/"));
        
              }, child: const Text("Regresar a inicio")),
      
              ]
            ),
          ),
      ),
    );
  }
}