import 'package:flutter/material.dart';

import '../market_models/market_snapshot.dart';
import '../market_services/market_service.dart';
import '../theme/app_theme.dart';

class ScreenMarket extends StatefulWidget {
  const ScreenMarket({super.key});

  @override
  State<ScreenMarket> createState() => _ScreenMarketState();
}

class _ScreenMarketState extends State<ScreenMarket> {
  final _service = MarketService();
  late Future<MarketSnapshot> _market;

  @override
  void initState() {
    super.initState();
    _market = _service.loadMarket();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final market = _service.loadMarket();
    setState(() => _market = market);
    await market;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MarketSnapshot>(
      future: _market,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _MarketError(onRetry: _refresh);
        }

        final market = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _BitcoinCard(quote: market.bitcoin),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chứng khoán Việt Nam',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (market.isVietnamSample)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Dữ liệu mô phỏng',
                        style: TextStyle(
                          color: Color(0xFFC2410C),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ...market.vietnamQuotes.map(
                (quote) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MarketQuoteTile(quote: quote),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cập nhật lúc ${_formatTime(market.updatedAt)}. Kéo xuống để làm mới.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BitcoinCard extends StatelessWidget {
  const _BitcoinCard({required this.quote});

  final MarketQuote quote;

  @override
  Widget build(BuildContext context) {
    final positive = (quote.changePercentage ?? 0) >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF172554), Color(0xFF0F766E)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F172A),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '₿',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bitcoin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'BTC / USD',
                      style: TextStyle(color: Color(0xFFCBD5E1)),
                    ),
                  ],
                ),
              ),
              const Text(
                'CoinGecko',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            quote.price == null
                ? 'Chưa có dữ liệu'
                : '\$${_formatNumber(quote.price!, decimals: 2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          if (quote.changePercentage != null)
            Row(
              children: [
                Icon(
                  positive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: positive
                      ? const Color(0xFF6EE7B7)
                      : const Color(0xFFFCA5A5),
                ),
                Text(
                  '${positive ? '+' : ''}${quote.changePercentage!.toStringAsFixed(2)}% trong 24 giờ',
                  style: TextStyle(
                    color: positive
                        ? const Color(0xFF6EE7B7)
                        : const Color(0xFFFCA5A5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MarketQuoteTile extends StatelessWidget {
  const _MarketQuoteTile({required this.quote});

  final MarketQuote quote;

  @override
  Widget build(BuildContext context) {
    final positive = (quote.changePercentage ?? 0) >= 0;
    final changeColor = positive ? AppColors.primaryDark : AppColors.danger;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                quote.symbol.substring(0, quote.symbol.length.clamp(0, 3)),
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.symbol,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    quote.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  quote.price == null
                      ? '--'
                      : _formatNumber(
                          quote.price!,
                          decimals: quote.unit == 'điểm' ? 2 : 0,
                        ),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  quote.changePercentage == null
                      ? '--'
                      : '${positive ? '+' : ''}${quote.changePercentage!.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketError extends StatelessWidget {
  const _MarketError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 52,
              color: AppColors.muted,
            ),
            const SizedBox(height: 12),
            const Text('Không thể tải dữ liệu thị trường.'),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}

String _formatNumber(double value, {required int decimals}) {
  final parts = value.toStringAsFixed(decimals).split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) buffer.write(',');
    buffer.write(digits[index]);
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return buffer.toString();
}

String _formatTime(DateTime value) {
  String twoDigits(int number) => number.toString().padLeft(2, '0');
  return '${twoDigits(value.hour)}:${twoDigits(value.minute)} '
      '${twoDigits(value.day)}/${twoDigits(value.month)}/${value.year}';
}
