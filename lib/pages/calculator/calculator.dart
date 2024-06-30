import 'package:bitcalc/widgets/text_field_calculator.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({
    super.key,
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  double selectedPrice = 0.0;
  String dropdownValue = 'USDT';
  List<String> currencies = ["USDT", "EUR", "GBP", "BRL"];
  bool isLoading = false;
  TextEditingController amountFiatController = TextEditingController();
  TextEditingController amountSatoshisController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTickerPrice();
  }

  void getTickerPrice() {
    amountFiatController.text = '1.0';
    amountSatoshisController.text = '346627.00000000';
    setState(() {
      selectedPrice = 346627.00000000;
      isLoading = false;
    });
  }

  void onChangeCurrency(String currency) {
    setState(() {
      dropdownValue = currency;
    });
    getTickerPrice();
  }

  @override
  Widget build(BuildContext context) {
    void calculateBitcoinAmount() {
      double amountFiat = double.tryParse(amountFiatController.text) ?? 0;
      double amountBitcoin = amountFiat / selectedPrice;

      amountSatoshisController.text = amountBitcoin.toString();
    }

    void calculateFiatAmount() {
      double amountBitcoin =
          double.tryParse(amountSatoshisController.text) ?? 0;
      double amountFiat = amountBitcoin * selectedPrice;

      amountFiatController.text = amountFiat.toString();
    }

    void onPressConfirm() {
      if (amountFiatController.text != "1") {
        calculateBitcoinAmount();
      } else if (amountSatoshisController.text != "346627.00000000") {
        calculateFiatAmount();
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(234, 92, 12, 230),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Center(
                child: Column(
                  children: [
                    Text(
                      'BitCalc',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'A Simple Bitcoin Calculator',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFieldCalculator(
                        textLabel: "Fiat Amount",
                        onChanged: (value) {
                          calculateBitcoinAmount();
                        },
                        textController: amountFiatController),
                    const SizedBox(height: 20),
                    TextFieldCalculator(
                        textLabel: "Bitcoin Satoshis",
                        onChanged: (value) {
                          calculateFiatAmount();
                        },
                        textController: amountSatoshisController),
                    const SizedBox(height: 20),
                    DropdownButtonFormField(
                        value: dropdownValue,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: Colors.yellow[800],
                        items: currencies
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.toString(),
                                  ),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value.toString();
                          });
                        }),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        onPressConfirm();
                      },
                      child: const Text('Refresh and Calculate'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
