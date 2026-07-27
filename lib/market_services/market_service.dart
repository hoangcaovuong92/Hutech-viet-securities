import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../market_models/market_snapshot.dart';

class MarketService {
  MarketService({FirebaseFirestore? firestore, http.Client? client})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _client = client ?? http.Client();

  final FirebaseFirestore _firestore;
  final http.Client _client;

  static const _bitcoinEndpoint =
      'https://api.coingecko.com/api/v3/simple/price'
      '?ids=bitcoin&vs_currencies=usd'
      '&include_24hr_change=true';

  static const _sampleVietnamQuotes = [
    MarketQuote(
      name: 'Chỉ số VN-Index',
      symbol: 'VN-INDEX',
      price: 1250,
      unit: 'điểm',
      changePercentage: 0.65,
    ),
    MarketQuote(
      name: 'Chỉ số HNX-Index',
      symbol: 'HNX-INDEX',
      price: 235,
      unit: 'điểm',
      changePercentage: -0.12,
    ),
    MarketQuote(
      name: 'Vietcombank',
      symbol: 'VCB',
      price: 89000,
      unit: 'VND',
      changePercentage: 0.9,
    ),
    MarketQuote(
      name: 'FPT Corporation',
      symbol: 'FPT',
      price: 132500,
      unit: 'VND',
      changePercentage: 1.2,
    ),
    MarketQuote(
      name: 'Tập đoàn Hòa Phát',
      symbol: 'HPG',
      price: 28300,
      unit: 'VND',
      changePercentage: -0.4,
    ),
  ];

  Future<MarketSnapshot> loadMarket() async {
    final results = await Future.wait([_loadBitcoin(), _loadVietnamMarket()]);
    final vietnam = results[1] as _VietnamMarketResult;

    return MarketSnapshot(
      bitcoin: results[0] as MarketQuote,
      vietnamQuotes: vietnam.quotes,
      isVietnamSample: vietnam.isSample,
      updatedAt: DateTime.now(),
    );
  }

  Future<MarketQuote> _loadBitcoin() async {
    try {
      final response = await _client
          .get(Uri.parse(_bitcoinEndpoint))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) throw const FormatException();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final bitcoin = body['bitcoin'] as Map<String, dynamic>;
      return MarketQuote(
        name: 'Bitcoin',
        symbol: 'BTC/USD',
        price: (bitcoin['usd'] as num?)?.toDouble(),
        unit: 'USD',
        changePercentage: (bitcoin['usd_24h_change'] as num?)?.toDouble(),
      );
    } catch (_) {
      return const MarketQuote(
        name: 'Bitcoin',
        symbol: 'BTC/USD',
        price: null,
        unit: 'USD',
        changePercentage: null,
      );
    }
  }

  Future<_VietnamMarketResult> _loadVietnamMarket() async {
    try {
      final document = await _firestore
          .collection('market_data')
          .doc('vietnam')
          .get();
      final values = document.data()?['quotes'];
      if (values is! List || values.isEmpty) {
        return const _VietnamMarketResult(_sampleVietnamQuotes, true);
      }
      final quotes = values
          .whereType<Map>()
          .map((item) => MarketQuote.fromMap(Map<String, dynamic>.from(item)))
          .toList();
      if (quotes.isEmpty) {
        return const _VietnamMarketResult(_sampleVietnamQuotes, true);
      }
      return _VietnamMarketResult(quotes, false);
    } catch (_) {
      return const _VietnamMarketResult(_sampleVietnamQuotes, true);
    }
  }

  void dispose() => _client.close();
}

class _VietnamMarketResult {
  const _VietnamMarketResult(this.quotes, this.isSample);

  final List<MarketQuote> quotes;
  final bool isSample;
}
