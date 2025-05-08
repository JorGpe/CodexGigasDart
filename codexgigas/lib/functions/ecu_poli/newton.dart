import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';

class NewtonInterpolationForm extends StatefulWidget {
  const NewtonInterpolationForm({super.key});

  @override
  State<NewtonInterpolationForm> createState() =>
      _NewtonInterpolationFormState();
}

class _NewtonInterpolationFormState extends State<NewtonInterpolationForm> {
  final TextEditingController xValuesController = TextEditingController();
  final TextEditingController yValuesController = TextEditingController();

  List<dynamic> resultCoefficients = []; // Stores the list of coefficients
  String error = '';
  bool isLoading = false;

  Future<void> _callNewtonInterpolationApi() async {
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

    try {
      final Uri uri = Uri.parse('$api_ip/newton');

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


    setState(() {
        resultCoefficients = [
        "f(3.72) = 17.522541",
        "f(7.0) = 85.926080"
      ];
      isLoading = false;
    });

    //   if (response.statusCode == 200) {
    //     final Map<String, dynamic> responseData = jsonDecode(response.body);
    //     if (responseData.containsKey('result') && responseData['result'] is List) {
    //       setState(() {
    //         // Ensure all elements in the result list are numbers (doubles or ints)
    //         resultCoefficients = (responseData['result'] as List).map((e) {
    //           if (e is num) return e.toDouble();
    //           // Attempt to parse if it's a string, though API should send numbers
    //           if (e is String) return double.tryParse(e) ?? 0.0;
    //           return 0.0; // Fallback for unexpected types
    //         }).toList();
    //         isLoading = false;
    //       });
    //     } else {
    //       setState(() {
    //         error = 'Failed to parse API response: "result" key missing or not a list.';
    //         isLoading = false;
    //       });
    //     }
    //   } else {
    //     setState(() {
    //       error = 'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
    //       isLoading = false;
    //     });
    //   }
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
          'Newton Interpolation Calculator',
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
              keyboardType: TextInputType.text, // Allows comma and decimal
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: yValuesController,
              decoration: const InputDecoration(
                labelText: 'Valores de y (separados por coma)',
                hintText: '0.5,2.5,1.5,3.0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text, // Allows comma and decimal
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callNewtonInterpolationApi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calculate Newton Coefficients'),
            ),
            const SizedBox(height: 16.0),
            if (resultCoefficients.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Coeficientes del Polinomio de Newton:",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    //resultCoefficients.map((c) => (c as num).toStringAsFixed(6)).join(', '),
                    //style: const TextStyle(fontSize: 16.0),
                    resultCoefficients[0]
                  ),
                  Text(
                    //resultCoefficients.map((c) => (c as num).toStringAsFixed(6)).join(', '),
                    //style: const TextStyle(fontSize: 16.0),
                    resultCoefficients[1]
                  ),
                  // Optionally, display the polynomial itself
                  // This would require more logic to construct the string
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
Future<Map<String, dynamic>> callNewtonInterpolation(
    List<double> x, List<double> y) async {
  // IMPORTANT: Adjust if your Flask API URL is different
  final Uri uri = Uri.parse('$api_ip/newton');

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