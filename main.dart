import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(GoldCalculatorApp());
}

class GoldCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.amber,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 14),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: GoldCalculatorScreen(),
    );
  }
}

class GoldCalculatorScreen extends StatefulWidget {
  @override
  _GoldCalculatorScreenState createState() => _GoldCalculatorScreenState();
}

class _GoldCalculatorScreenState extends State<GoldCalculatorScreen> {
  final _ounceController = TextEditingController();
  final _dollarController = TextEditingController();
  final _wageController = TextEditingController(text: '200000');
  final _profitController = TextEditingController(text: '7');
  final _taxController = TextEditingController(text: '9');

  String _rawPrice = '';
  String _finalPrice = '';

  void _calculate() {
    final ounce = double.tryParse(_ounceController.text);
    final dollar = double.tryParse(_dollarController.text);
    final wage = double.tryParse(_wageController.text) ?? 0;
    final profitPercent = double.tryParse(_profitController.text) ?? 0;
    final taxPercent = double.tryParse(_taxController.text) ?? 0;

    if (ounce == null || dollar == null) {
      setState(() {
        _rawPrice = 'Invalid input';
        _finalPrice = '';
      });
      return;
    }

    final raw = (ounce * dollar) / 41.4;
    final profit = (raw + wage) * (profitPercent / 100);
    final tax = (raw + wage + profit) * (taxPercent / 100);
    final finalPrice = raw + wage + profit + tax;

    final formatter = NumberFormat.decimalPattern('fa');
    setState(() {
      _rawPrice = 'قیمت خام: ${formatter.format(raw.round())} تومان';
      _finalPrice = 'قیمت نهایی: ${formatter.format(finalPrice.round())} تومان';
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, String suffix) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gold Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField('قیمت اونس (دلار)', _ounceController, 'دلار'),
            _buildTextField('قیمت دلار (تومان)', _dollarController, 'تومان'),
            Divider(height: 32, color: Colors.amber),
            _buildTextField('اجرت هر گرم', _wageController, 'تومان'),
            _buildTextField('درصد سود فروشنده', _profitController, '%'),
            _buildTextField('درصد مالیات', _taxController, '%'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: Text('محاسبه'),
            ),
            SizedBox(height: 20),
            if (_rawPrice.isNotEmpty)
              Text(_rawPrice, style: TextStyle(fontSize: 18, color: Colors.amber)),
            if (_finalPrice.isNotEmpty)
              Text(_finalPrice, style: TextStyle(fontSize: 20, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}