import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculadoraScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _output = "0";
  String _input = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operator = "";

  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _operatorController = TextEditingController();

  final List<String> _historial = [];

  void _guardarEnHistorial(String operacion) {
    _historial.add(operacion);
  }

  void _syncInputWithTextField(String value) {
    _input = value;
    // Si hay operador, muestra "num1 operador input"
    if (_operator.isNotEmpty) {
      // si _num1 es infinito/NaN o no inicializado, intenta parsear output
      String left = (_num1 != 0 || _output != "0") ? _num1.toString() : _output;
      _output = "$left $_operator ${_input.isEmpty ? '' : _input}";
    } else {
      // sin operador, sólo muestra el input (o 0 si vacío)
      _output = _input.isEmpty ? "0" : _input;
    }
    setState(() {});
  }

  void _buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        // Limpia todo
        _output = "0";
        _input = "";
        _num1 = 0;
        _num2 = 0;
        _operator = "";
        _inputController.text = "";
        _operatorController.text = "";
        _historial.clear();
        return;
      }

      // Si se pulsa un operador
      if (value == "+" || value == "-" || value == "x" || value == "/") {
        // Si no hay input pero sí hay un resultado previo, se usa como num1
        if (_input.isEmpty) {
          // si _output es "Error" no lo usa (= 0)
          if (_output != "Error") {
            _num1 = double.tryParse(_output) ?? _num1;
          }
        } else {
          _num1 =
              double.tryParse(_input) ??
              (_output != "Error" ? double.tryParse(_output) ?? 0 : 0);
        }

        _operator = value;
        _operatorController.text = value;
        // Deja el _input vacío para que se introduzca el nuevo número
        _input = "";
        _inputController.text = "";
        // Muestra "num1 operador" en el display
        _output = "${_num1.toString()} $_operator";
        return;
      }

      // Si se pulsa "="
      if (value == "=") {
        _num2 = double.tryParse(_input) ?? 0;

        String operacionCompleta = "";
        String resultadoStr = "";

        switch (_operator) {
          case "+":
            resultadoStr = (_num1 + _num2).toString();
            operacionCompleta = "$_num1 + $_num2 = $resultadoStr";
            break;
          case "-":
            resultadoStr = (_num1 - _num2).toString();
            operacionCompleta = "$_num1 - $_num2 = $resultadoStr";
            break;
          case "x":
            resultadoStr = (_num1 * _num2).toString();
            operacionCompleta = "$_num1 × $_num2 = $resultadoStr";
            break;
          case "/":
            if (_num2 == 0) {
              resultadoStr = "Error";
              operacionCompleta = "$_num1 ÷ $_num2 = Error";
            } else {
              resultadoStr = (_num1 / _num2).toString();
              operacionCompleta = "$_num1 ÷ $_num2 = $resultadoStr";
            }
            break;
          default:
            // sin operador NO hace nada
            return;
        }

        _guardarEnHistorial(operacionCompleta);

        // Muestra el resultado en el display
        _output = resultadoStr;

        // Guarda el resultado como número previo para la próxima operación (si no es Error)
        if (resultadoStr != "Error") {
          _num1 = double.tryParse(resultadoStr) ?? _num1;
        }

        // limpia los TextFields
        _input = "";
        _inputController.text = "";
        _operator = "";
        _operatorController.text = "";
        return;
      }

      // Si es número o punto
      // concatena dígito/punto al input y sincronizar el textfield y el display
      _input += value;
      _inputController.text = _input;

      // si ya hay operador, muestra "num1 operador input"
      if (_operator.isNotEmpty) {
        _output = "${_num1.toString()} $_operator $_input";
      } else {
        _output = _input;
      }
    });
  }

  Widget _buildButton(String value, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: color,
          ),
          onPressed: () => _buttonPressed(value),
          child: Text(
            value,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900], 
        centerTitle: true, 
        title: const Text(
          "Calculadora básica",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),
      ),

      body: Column(
        children: [
          
          // Display principal
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(10),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // TextFields en la misma fila
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _operatorController,
                    textAlign: TextAlign.center,
                    onChanged: (op) {
                      if (op == "+" || op == "-" || op == "x" || op == "/") {
                        setState(() {
                          _operator = op;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Op",
                      hintText: "+ - x /",
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    onChanged: _syncInputWithTextField,
                    decoration: const InputDecoration(
                      labelText: "Número actual",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Historial
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: _historial.length,
              itemBuilder: (context, index) {
                return Text(
                  _historial[index],
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ),

          // Botonera
          Column(
            children: [
              Row(children: [_buildButton("=", color: Colors.blue)]),
              Row(
                children: [
                  _buildButton("7", color: Colors.black),
                  _buildButton("8", color: Colors.black),
                  _buildButton("9", color: Colors.black),
                  _buildButton("/", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton("4", color: Colors.black),
                  _buildButton("5", color: Colors.black),
                  _buildButton("6", color: Colors.black),
                  _buildButton("x", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton("1", color: Colors.black),
                  _buildButton("2", color: Colors.black),
                  _buildButton("3", color: Colors.black),
                  _buildButton("-", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton(".", color: Colors.black),
                  _buildButton("0", color: Colors.black),
                  _buildButton("C", color: Colors.red),
                  _buildButton("+", color: Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
