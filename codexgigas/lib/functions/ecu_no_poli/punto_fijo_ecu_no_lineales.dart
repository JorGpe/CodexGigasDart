import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';

class PuntoFijoSistemasForm extends StatefulWidget {
  const PuntoFijoSistemasForm({super.key});

  @override
  State<PuntoFijoSistemasForm> createState() =>
      _PuntoFijoSistemasFormState();
}

class _PuntoFijoSistemasFormState
    extends State<PuntoFijoSistemasForm> {
  final TextEditingController funcionesController = TextEditingController();
  final TextEditingController variablesController = TextEditingController();
  final TextEditingController valoresInicialesController =
      TextEditingController();

  var result = []; // Will store [[raices_list], iteraciones_count]
  String error = '';
  bool isLoading = false;

  Future<void> _callPuntoFijoSistemasApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionesInput = funcionesController.text;
    final String variablesInput = variablesController.text;
    final String valoresInicialesInput = valoresInicialesController.text;

    if (funcionesInput.isEmpty ||
        variablesInput.isEmpty ||
        valoresInicialesInput.isEmpty) {
      setState(() {
        isLoading = false;
        error = 'Please fill in all fields.';
      });
      return;
    }

    List<String> listaFunciones = funcionesInput.split('\n').where((f) => f.trim().isNotEmpty).toList();
    List<String> listaVariables = variablesInput.split(',').map((v) => v.trim()).where((v) => v.isNotEmpty).toList();
    List<double> listaValoresIniciales = [];

    try {
      listaValoresIniciales = valoresInicialesInput
          .split(',')
          .map((v) => double.parse(v.trim()))
          .toList();
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Invalid format for initial values. Please use comma-separated numbers.';
      });
      return;
    }

    if (listaFunciones.isEmpty || listaVariables.isEmpty || listaValoresIniciales.isEmpty) {
        setState(() {
        isLoading = false;
        error = 'Fields cannot be empty after parsing. Check your inputs.';
      });
      return;
    }

    if (listaFunciones.length != listaVariables.length ||
        listaVariables.length != listaValoresIniciales.length) {
      setState(() {
        isLoading = false;
        error =
            'The number of functions, variables, and initial values must match.';
      });
      return;
    }

    try {

      final Uri uri = Uri.parse('$api_ip/punto_fijo_ecu_no_lineales');

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'lista_funciones': listaFunciones, // These are the g_i(vars) functions
          'string_variables': variablesInput,
          'lista_x': listaValoresIniciales,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('result') &&
            responseData['result'] is List &&
            (responseData['result'] as List).length >= 2 &&
            (responseData['result'] as List)[0] is List &&
            (responseData['result'] as List)[1] is num) {
          setState(() {
            result = responseData['result'];
            isLoading = false;
          });
        } else {
          setState(() {
            error =
                'Failed to parse API response: "result" key malformed or missing required data.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error =
              'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error calling API: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Punto Fijo Systems Calculator',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: funcionesController,
              decoration: const InputDecoration(
                labelText: 'Funciones de Iteración gᵢ (xᵢ = gᵢ(vars), una por línea)',
                hintText: 'Ej: (y+3)/x \nsqrt(x+1)', // Example g1 and g2 for x=g1, y=g2
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null, 
              minLines: 3,    
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: variablesController,
              decoration: const InputDecoration(
                labelText: 'Variables (ej. x,y,z)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: valoresInicialesController,
              decoration: const InputDecoration(
                labelText: 'Valores Iniciales (ej. 1.0,0.5,2.0)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text, 
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callPuntoFijoSistemasApi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calculate Punto Fijo Systems'),
            ),
            const SizedBox(height: 16.0),
            if (result.isNotEmpty &&
                result.length >= 2 &&
                result[0] is List &&
                result[1] is num)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Raíces:",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    (result[0] as List<dynamic>)
                        .map((e) => (e is num) ? e.toStringAsFixed(6) : e.toString())
                        .join(', '),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                   Row(
                     children: [
                       const Text(
                         "Iteraciones: ",
                         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                       ),
                       Text(
                         (result[1] as num).toStringAsFixed(0),
                         style: const TextStyle(fontSize: 18.0),
                       ),
                     ],
                   ),
                ],
              ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  error,
                  style: const TextStyle(fontSize: 16.0, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Standalone API call function
Future<Map<String, dynamic>> callPuntoFijoSistemas(
  List<String> funciones, String variables, List<double> x) async {

  final Uri uri = Uri.parse('$api_ip/punto_fijo_ecu_no_lineales');
  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'lista_funciones': funciones, // Iterative functions g_i(vars)
        'string_variables': variables, 
        'lista_x': x,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}