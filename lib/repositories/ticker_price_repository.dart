import 'package:bitcalc/models/ticker_price_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class TickerPriceRepository {
  Future<TickerPriceModel> fetchPrice(String symbol) async {
    var dio = Dio();
    var apiUrl = dotenv.get("API_URL");

    var result = await dio.get('$apiUrl/ticker/price?symbol=$symbol');
    if (result.statusCode != 200) {
      throw Exception();
    }
    var tickerPriceModel = TickerPriceModel.fromJson(result.data);

    return tickerPriceModel;
  }
}
