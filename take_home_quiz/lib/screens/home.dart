import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrentCurrency = 'USD';
  String selectedTargetCurrency = 'PHP';
  TextEditingController amountController = TextEditingController();
  String convertedAmount = '';
  
  void convertCurrency() async {
    final apiKey = '710883582ed944dba8343f4fff88a6d2';
    final response = await http.get(Uri.parse('https://openexchangerates.org/api/latest.json?app_id=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> rates = responseData['rates'];
      final double currentRate = rates[selectedCurrentCurrency].toDouble();
      final double targetRate = rates[selectedTargetCurrency].toDouble();
      final double amount = double.tryParse(amountController.text) ?? 0;

      final double convertedAmountInTargetCurrency = (amount / currentRate) * targetRate;

      setState(() {
        convertedAmount = convertedAmountInTargetCurrency.toStringAsFixed(2);
      });
    } else {
      setState(() {
        convertedAmount = 'Error: Failed to fetch exchange rates';
      });
    }
  }

  String _getCurrencyName(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'British Pound';
      case 'JPY':
        return 'Japanese Yen';
      case 'CAD':
        return 'Canadian Dollar';
      case 'RUB':
        return 'Russian Ruble';
      case 'PHP':
        return 'Philippine Peso';
      case 'SAR':
        return 'Saudi Arabian Riyal';
      default:
        return currencyCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert.io'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedCurrentCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCurrentCurrency = newValue!;
                      });
                    },
                    items: <String>[
                      'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'RUB', 'PHP', 'SAR'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(_getCurrencyName(value)),
                      );
                    }).toList(),
                  ),
                  Text('to'),
                  DropdownButton<String>(
                    value: selectedTargetCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTargetCurrency = newValue!;
                      });
                    },
                    items: <String>[
                      'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'RUB', 'PHP', 'SAR'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(_getCurrencyName(value)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter amount',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  convertCurrency();
                },
                child: Text('Convert'),
              ),
              SizedBox(height: 20),
              Text(
                'Converted Amount: ',
                style: TextStyle(fontSize: 20),
              ),
              Text('$convertedAmount',
              style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }

}
