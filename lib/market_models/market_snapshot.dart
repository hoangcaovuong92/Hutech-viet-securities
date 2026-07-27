class MarketQuote {
  const MarketQuote({
    required this.name,
    required this.symbol,
    required this.price,
    required this.unit,
    required this.changePercentage,
  });

  final String name;
  final String symbol;
  final double? price;
  final String unit;
  final double? changePercentage;

  factory MarketQuote.fromMap(Map<String, dynamic> map) {
    return MarketQuote(
      name: map['name']?.toString() ?? '',
      symbol: map['symbol']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble(),
      unit: map['unit']?.toString() ?? 'VND',
      changePercentage: (map['changePercentage'] as num?)?.toDouble(),
    );
  }
}

class MarketSnapshot {
  const MarketSnapshot({
    required this.bitcoin,
    required this.vietnamQuotes,
    required this.isVietnamSample,
    required this.updatedAt,
  });

  final MarketQuote bitcoin;
  final List<MarketQuote> vietnamQuotes;
  final bool isVietnamSample;
  final DateTime updatedAt;
}
