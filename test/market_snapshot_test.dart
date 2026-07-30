import 'package:flutter_test/flutter_test.dart';
import 'package:viet_securities/market_models/market_snapshot.dart';

void main() {
  test('MarketQuote đọc đúng dữ liệu từ Firestore', () {
    final quote = MarketQuote.fromMap(const {
      'name': 'Chỉ số VN-Index',
      'symbol': 'VN-INDEX',
      'price': 1250,
      'unit': 'điểm',
      'changePercentage': 0.65,
    });

    expect(quote.symbol, 'VN-INDEX');
    expect(quote.price, 1250.0);
    expect(quote.changePercentage, 0.65);
  });
}
