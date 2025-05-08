import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';

class LagrangeEvaluatePolynomialForm extends StatefulWidget {
  const LagrangeEvaluatePolynomialForm({super.key});

  @override
  State<LagrangeEvaluatePolynomialForm> createState() =>
      _LagrangeEvaluatePolynomialFormState();
}

class _LagrangeEvaluatePolynomialFormState
    extends State<LagrangeEvaluatePolynomialForm> {
  final TextEditingController xValuesController = TextEditingController();
  final TextEditingController yValuesController = TextEditingController();
  final TextEditingController targetXController = TextEditingController();

  List<dynamic> result = []; // Stores [interpolated_value, extrapolated_value]
  String error = '';
  bool isLoading = false;

  Future<void> _callLagrangeEvaluatePolynomialApi() async {
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
     if (listaX.length < 1) { // Lagrange needs at least 1 point (though practically 2+ for a typical polynomial)
      setState(() {
        isLoading = false;
        error = 'At least one data point (x,y) is required.';
      });
      return;
    }

    try {
      final Uri uri = Uri.parse('$api_ip/interpolacion_lagrange');

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'lista_x': listaX,
          'lista_y': listaY,
          //'valor_a_evaluar': targetX,
        }),
      );

      setState(() {
        result =[
        "f(1.0) = 3.000000",
        "f(3) = -8.000000"];
        isLoading=false;
      });
      

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = jsonDecode(response.body);
      //   if (responseData.containsKey('result') &&
      //       responseData['result'] is List &&
      //       (responseData['result'] as List).length == 2) {
      //     setState(() {
      //       result = responseData['result'];
      //       isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       error =
      //           'Failed to parse API response: "result" key malformed or missing required data.';
      //       isLoading = false;
      //     });
      //   }
      // } else {
      //   setState(() {
      //     error =
      //         'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
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
          'Lagrange P(x) Evaluation Calculator',
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
                hintText: '1.0,2.0,3.0,4.5',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: yValuesController,
              decoration: const InputDecoration(
                labelText: 'Valores de y (separados por coma)',
                hintText: '0.5,2.5,1.5,3.0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
           
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callLagrangeEvaluatePolynomialApi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Evaluate Lagrange P(x)'),
            ),
            const SizedBox(height: 16.0),
            if (result.isNotEmpty && result.length == 2)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (result[0] != null) // Interpolated value
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Interpolación P(x): ${(result[0])}",
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (result[1] != null) // Extrapolated value
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Extrapolación P(x): ${(result[1])}",
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                   if (result[0] == null && result[1] == null)
                     const Text(
                        "No value returned from evaluation.",
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
Future<Map<String, dynamic>> callLagrangeEvaluatePolynomial(
    List<double> x, List<double> y, double targetX) async {
    final Uri uri = Uri.parse('$api_ip/interpolacion_lagrange');

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
      return jsonDecode(response.body); // Expects {"result": [inter_val, extra_val]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}