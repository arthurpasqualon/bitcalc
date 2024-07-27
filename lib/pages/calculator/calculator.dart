import 'package:bitcalc/repositories/ticker_price_repository.dart';
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
  String amountBitcoinValue = "BTC";
  List<String> bitcoinValues = ["BTC", "SATS"];
  bool isLoading = false;
  TextEditingController amountFiatController = TextEditingController();
  TextEditingController amountBitcoinController = TextEditingController();
  late TickerPriceRepository tickerPriceRepository;

  @override
  void initState() {
    super.initState();
    tickerPriceRepository = TickerPriceRepository();
    getTickerPrice();
  }

  void calculateBitcoinAmount() {
    double amountFiat = double.tryParse(amountFiatController.text) ?? 0;
    double amountBitcoin;
    if (amountBitcoinValue == "SATS") {
      amountBitcoin = (amountFiat / selectedPrice) * 100000000;
      amountBitcoinController.text = amountBitcoin.toStringAsFixed(0);
    } else {
      amountBitcoin = amountFiat / selectedPrice;
      amountBitcoinController.text = amountBitcoin.toStringAsFixed(8);
    }
  }

  void calculateFiatAmount() {
    double amountBitcoin = double.tryParse(amountBitcoinController.text) ?? 0;
    double amountFiat;

    if (amountBitcoinValue == "SATS") {
      amountFiat = (amountBitcoin * 100000000) * selectedPrice;
    } else {
      amountFiat = amountBitcoin * selectedPrice;
    }

    amountFiatController.text = amountFiat.toStringAsFixed(2);
  }

  void getTickerPrice() async {
    var result = await tickerPriceRepository.fetchPrice("BTC$dropdownValue");
    if (result.price != null) {
      if (amountFiatController.text.isEmpty) {
        amountFiatController.text = "1.0";
      }
      setState(() {
        selectedPrice = double.tryParse(result.price ?? "0.0") ?? 0.0;
        isLoading = false;
      });
      calculateBitcoinAmount();
    }
  }

  void onChangeCurrency(String currency) {
    setState(() {
      dropdownValue = currency;
    });
    getTickerPrice();
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFieldCalculator(
                          textLabel: amountBitcoinValue,
                          onChanged: (value) {
                            calculateFiatAmount();
                          },
                          textController: amountBitcoinController),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField(
                          value: amountBitcoinValue,
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white),
                          dropdownColor: Colors.yellow[800],
                          items: bitcoinValues
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
                              amountBitcoinValue = value.toString();
                            });
                            calculateBitcoinAmount();
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFieldCalculator(
                          textLabel: "Fiat Amount",
                          onChanged: (value) {
                            calculateBitcoinAmount();
                          },
                          textController: amountFiatController),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField(
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
                            onChangeCurrency(value.toString());
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    getTickerPrice();
                  },
                  child: const Text('Refresh and Calculate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
