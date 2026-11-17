class Quote {
  const Quote({
    required this.pair,
    required this.bid,
    required this.sourceName,
    required this.fetchedAt,
  });

  final String pair;
  final double bid;
  final String sourceName;
  final DateTime fetchedAt;

  factory Quote.fromAwesomeApiJson(
    Map<String, dynamic> json, {
    required String sourceName,
  }) {
    final entry = json.values.first as Map<String, dynamic>;
    return Quote(
      pair: '${entry['code']}/${entry['codein']}',
      bid: double.parse(entry['bid'] as String),
      sourceName: sourceName,
      fetchedAt: DateTime.now(),
    );
  }
}
