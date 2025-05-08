import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';


class VandermondeForm extends StatefulWidget {
  const VandermondeForm({super.key});

  @override
  State<VandermondeForm> createState() => _VandermondeFormState();
}

class _VandermondeFormState extends State<VandermondeForm> {
  final TextEditingController xValuesController = TextEditingController();
  final TextEditingController yValuesController = TextEditingController();

  List<dynamic> resultCoefficients = []; // Stores the list of coefficients
  String error = '';
  bool isLoading = false;

  Future<void> _callVandermondeApi() async {
    setState(() {
      isLoading = true;
      resultCoefficients = [];
      error = '';
    });

    final String xValuesInput = xValuesController.text;
    final String yValuesInput = yValuesController.text;

    if (xValuesInput.isEmpty || yValuesInput.isEmpty) {
      setState(() {
        isLoading = false;
        error = 'Please enter both x and y values.';
      });
      return;
    }

    List<double> listaX;
    List<double> listaY;

    try {
      listaX = xValuesInput
          .split(',')
          .map((val) => double.parse(val.trim()))
          .toList();
      listaY = yValuesInput
          .split(',')
          .map((val) => double.parse(val.trim()))
          .toList();
      
      if (listaX.isEmpty || listaY.isEmpty) throw FormatException("Empty list after parsing.");

    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Invalid format for x or y values. Please use comma-separated numbers.';
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
     if (listaX.length < 2) { // Vandermonde typically needs at least 2 points for a line
      setState(() {
        isLoading = false;
        error = 'At least two data points (x,y) are required.';
      });
      return;
    }


    try {
      final Uri uri = Uri.parse('$api_ip/vandermode');

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'lista_x': listaX,
          'lista_y': listaY,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('result') && responseData['result'] is List) {
           setState(() {
            resultCoefficients = (responseData['result'] as List).map((e) {
              if (e is num) return e.toDouble();
              if (e is String) return double.tryParse(e) ?? 0.0;
              return 0.0; 
            }).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            error = 'Failed to parse API response: "result" key missing or not a list.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
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
          'Vandermonde Interpolation Calculator',
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
                hintText: '1.0,2.0,3.0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: yValuesController,
              decoration: const InputDecoration(
                labelText: 'Valores de y (separados por coma)',
                hintText: '0.5,2.5,1.5',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callVandermondeApi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calculate Vandermonde Coefficients'),
            ),
            const SizedBox(height: 16.0),
            if (resultCoefficients.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Coeficientes del Polinomio (a₀, a₁, ...):",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    resultCoefficients.map((c) => (c as num).toStringAsFixed(6)).join(', '),
                    style: const TextStyle(fontSize: 16.0),
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
Future<Map<String, dynamic>> callVandermonde(
    List<double> x, List<double> y) async {
  final Uri uri = Uri.parse('$api_ip/vandermode');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'lista_x': x,
        'lista_y': y,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [coefficients...]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}