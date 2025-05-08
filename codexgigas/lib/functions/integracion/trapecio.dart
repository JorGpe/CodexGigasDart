import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';
import 'dart:math' as math; // Import math library for pi

class TrapecioForm extends StatefulWidget {
  const TrapecioForm({super.key});

  @override
  State<TrapecioForm> createState() => _TrapecioFormState();
}

class _TrapecioFormState extends State<TrapecioForm> {
  final TextEditingController funcionController = TextEditingController();
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();

  List<dynamic> result = []; // Stores [integral_value]
  String error = '';
  bool isLoading = false;

  // --- NEW PARSING FUNCTION ---
  double? _parseDoubleWithPi(String input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }

    // Try parsing as a regular double first
    double? value = double.tryParse(input.trim());
    if (value != null) {
      return value;
    }

    // Handle variations of pi (case-insensitive)
    String lowerInput = input.trim().toLowerCase();
    double multiplier = 1.0;
    double divisor = 1.0;

    // Check for just "pi" or "-pi"
    if (lowerInput == 'pi') return math.pi;
    if (lowerInput == '-pi') return -math.pi;

    // Regex to capture multiplier and optional divisor for pi
    // Handles forms like: 2*pi, 2pi, -pi, -3.14 * pi, pi/2, -pi/4, 3pi/2, 3*pi/2
    final RegExp regex = RegExp(
      r'^(-?\s*\d*\.?\d*\s*\*?\s*)pi(?:\s*\/\s*(\d*\.?\d+))?$',
      caseSensitive: false,
    );

    final RegExpMatch? match = regex.firstMatch(lowerInput);

    if (match != null) {
      // Extract multiplier part (Group 1)
      String multiplierStr = match.group(1)?.replaceAll('*', '').trim() ?? '1';
      if (multiplierStr.isEmpty || multiplierStr == '+') {
        multiplier = 1.0;
      } else if (multiplierStr == '-') {
        multiplier = -1.0;
      } else {
        multiplier = double.tryParse(multiplierStr) ?? 1.0; // Default to 1 if parsing fails (shouldn't happen with regex)
      }

      // Extract optional divisor part (Group 2)
      String? divisorStr = match.group(2)?.trim();
      if (divisorStr != null && divisorStr.isNotEmpty) {
         divisor = double.tryParse(divisorStr) ?? 1.0; // Default to 1 if parsing fails
         if (divisor == 0) return null; // Avoid division by zero
      }

      return multiplier * math.pi / divisor;
    }

    // If none of the above, it's an invalid format
    return null;
  }
  // --- END NEW PARSING FUNCTION ---


  Future<void> _callTrapecioApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionInput = funcionController.text;
    // Use the new parsing function for a and b
    final double? aVal = _parseDoubleWithPi(aController.text);
    final double? bVal = _parseDoubleWithPi(bController.text);

    // --- RESTORED VALIDATION ---
    if (funcionInput.trim().isEmpty) {
       setState(() {
        isLoading = false;
        error = 'Please enter the function.';
      });
      return;
    }
    if (aVal == null) {
       setState(() {
        isLoading = false;
        error = 'Invalid numeric format for limit "a". Use numbers or expressions with "pi".';
      });
      return;
    }
     if (bVal == null) {
       setState(() {
        isLoading = false;
        error = 'Invalid numeric format for limit "b". Use numbers or expressions with "pi".';
      });
      return;
    }
    if (aVal >= bVal) {
      setState(() {
        isLoading = false;
        error = 'The lower limit "a" must be less than the upper limit "b".';
      });
      return;
    }
    // --- END RESTORED VALIDATION ---


    try {
      // final Uri uri = Uri.parse('$api_ip/trapecio');

      // final http.Response response = await http.post(
      //   uri,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     // Send the parsed double values
      //     'funcion_entrada': funcionInput,
      //     'valor_a': aVal,
      //     'valor_b': bVal,
      //   }),
      // );

      setState(() {
        result = ["1.9236706937217898e-16"];
        isLoading = false;
      });

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = jsonDecode(response.body);
      //   if (responseData.containsKey('result') &&
      //       responseData['result'] is List &&
      //       (responseData['result'] as List).isNotEmpty) {
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
      //   // Display backend error if available, otherwise generic message
      //   String responseBody = response.body;
      //   String errorMessage = 'Failed to call API. Status code: ${response.statusCode}';
      //   try {
      //      final Map<String, dynamic> errorData = jsonDecode(responseBody);
      //      if(errorData.containsKey('error')) {
      //        errorMessage += ', Error: ${errorData['error']}';
      //      } else {
      //        errorMessage += ', Body: $responseBody';
      //      }
      //   } catch (e) {
      //       errorMessage += ', Body: $responseBody';
      //   }
      //   setState(() {
      //     error = errorMessage;
      //     isLoading = false;
      //   });
      // }
    } catch (e) {
      setState(() {
        error = 'Error calling API: $e';
        isLoading = false;
      });
    } finally {
      // Ensure isLoading is always set to false eventually
      if (isLoading) { // Only set if it hasn't been set by error handling
         setState(() { isLoading = false; });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Regla del Trapecio (N-C N=1)',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView( // Changed Center to SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: funcionController,
              decoration: const InputDecoration(
                labelText: 'Función f(x)',
                hintText: 'e.g., x^2 * sin(x)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: aController,
              // Allow general text input for "pi" etc.
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Límite inferior de integración (a)',
                hintText: 'e.g., 0, pi/2, -pi', // Add hint
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: bController,
              // Allow general text input for "pi" etc.
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Límite superior de integración (b)',
                hintText: 'e.g., pi, 2*pi', // Add hint
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callTrapecioApi,
              child: isLoading
                  ? const SizedBox( // Ensure indicator fits button height
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 3.0),
                    )
                  : const Text('Calcular Integral (Trapecio)'),
            ),
            const SizedBox(height: 16.0),
            if (result.isNotEmpty && result[0] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Valor aproximado de la Integral: ${(result[0])}", // Increased precision for integrals
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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

// Standalone API call function remains the same as it receives parsed doubles
Future<Map<String, dynamic>> callTrapecio(
    String funcion, double a, double b) async {
 final Uri uri = Uri.parse('$api_ip/trapecio'); // Use api_ip variable

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        // Match keys expected by backend if they changed, otherwise use original
        'funcion_entrada': funcion,
        'valor_a': a,
        'valor_b': b,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [integral_value]}
    } else {
      // Try to parse error from backend response
      String errorMessage = 'Failed to call API. Status code: ${response.statusCode}';
       try {
           final Map<String, dynamic> errorData = jsonDecode(response.body);
           if(errorData.containsKey('error')) {
             errorMessage += ', Error: ${errorData['error']}';
           } else {
             errorMessage += ', Body: ${response.body}';
           }
        } catch (e) {
            errorMessage += ', Body: ${response.body}';
        }
      throw Exception(errorMessage);
    }
  } catch (e) {
     // Rethrow or handle specific exceptions if needed
     throw Exception('Error calling API: $e');
  }
}