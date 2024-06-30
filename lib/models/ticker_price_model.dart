class TickerPriceModel {
  String? symbol;
  String? price;

  TickerPriceModel({this.symbol, this.price});

  TickerPriceModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['price'] = price;
    return data;
  }
}
