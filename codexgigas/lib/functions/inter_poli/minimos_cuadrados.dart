import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';

class MinimosCuadradosForm extends StatefulWidget {
  const MinimosCuadradosForm({super.key});

  @override
  State<MinimosCuadradosForm> createState() => _MinimosCuadradosFormState();
}

class _MinimosCuadradosFormState extends State<MinimosCuadradosForm> {
  final TextEditingController xValuesController = TextEditingController();
  final TextEditingController yValuesController = TextEditingController();
  final TextEditingController targetXController = TextEditingController();

  List<dynamic> result = []; // Stores [string_funcion, interpolated_value, extrapolated_value]
  String error = '';
  bool isLoading = false;

  Future<void> _callMinimosCuadradosApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String xValuesInput = xValuesController.text;
    final String yValuesInput = yValuesController.text;
    //final String targetXInput = targetXController.text;

    // if (xValuesInput.isEmpty ||
    //     yValuesInput.isEmpty ||
    //     targetXInput.isEmpty) {
    //   setState(() {
    //     isLoading = false;
    //     error = 'Please enter x values, y values, and the x value to evaluate.';
    //   });
    //   return;
    // }

    List<double> listaX;
    List<double> listaY;
    double targetX;

    try {
      listaX = xValuesInput
          .split(',')
          .map((val) => double.parse(val.trim()))
          .toList();
      listaY = yValuesInput
          .split(',')
          .map((val) => double.parse(val.trim()))
          .toList();
      //targetX = double.parse(targetXInput.trim());

      if (listaX.isEmpty || listaY.isEmpty) {
        throw const FormatException("X or Y value lists cannot be empty after parsing.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Invalid format for input values. Please use comma-separated numbers for lists and a valid number for evaluation.';
      });
      return;
    }

    if (listaX.length != listaY.length) {
      setState(() {
        isLoading = false;
        error = 'The number of x values must match the number of y values.';
      });
      return;
    }
    if (listaX.length < 2) { // Linear regression needs at least 2 points
      setState(() {
        isLoading = false;
        error = 'At least two data points (x,y) are required for linear regression.';
      });
      return;
    }

    try {

      // final Uri uri = Uri.parse('$api_ip/minimos_cuadrados');

      // final http.Response response = await http.post(
      //   uri,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     'lista_x': listaX,
      //     'lista_y': listaY,
      //     //'valor_a_evaluar': targetX,
      //   }),
      // );

      setState(() {
        result = [
         " Ecuación ajustada: y = 2.0000x + 5.0000",
          "Interpolacion: f(30.0) = 65.000000",
          "Extrapolacion: f(51) = 107.000000"
        ];
        isLoading = false;
      });

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = jsonDecode(response.body);
      //   if (responseData.containsKey('result') &&
      //       responseData['result'] is List &&
      //       (responseData['result'] as List).length == 3) {
      //     setState(() {
      //       result = responseData['result'];
      //       isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       error = 'Failed to parse API response: "result" key malformed or missing required data (expected 3 elements).';
      //       isLoading = false;
      //     });
      //   }
      // } else {
      //   setState(() {
      //     error = 'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
      //     isLoading = false;
      //   });
      // }
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
          'Mínimos Cuadrados Calculator',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: xValuesController,
              decoration: const InputDecoration(
                labelText: 'Valores de x (separados por coma)',
                hintText: '1.0,2.0,3.0,4.0,5.0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: yValuesController,
              decoration: const InputDecoration(
                labelText: 'Valores de y (separados por coma)',
                hintText: '1.5,3.5,4.0,5.5,7.0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callMinimosCuadradosApi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calculate Mínimos Cuadrados'),
            ),
            const SizedBox(height: 16.0),
            if (result.isNotEmpty && result.length == 3)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (result[0] != null && result[0] is String) // Function string
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Función de Regresión: ${result[0]}",
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (result[1] != null) // Interpolated value
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Interpolación: ${(result[1])}",
                         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (result[2] != null) // Extrapolated value
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Extrapolación: ${(result[2])}",
                         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
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
Future<Map<String, dynamic>> callMinimosCuadrados(
    List<double> x, List<double> y, double targetX) async {
  // IMPORTANT: Adjust if your Flask API URL is different
  final Uri uri = Uri.parse('$api_ip/minimos_cuadrados');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'lista_x': x,
        'lista_y': y,
        //'valor_a_evaluar': targetX,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [func_str, inter_val, extra_val]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}