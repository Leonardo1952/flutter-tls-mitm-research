import 'package:flutter/material.dart';

import 'models/quote.dart';
import 'services/quote_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rate Today'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'EasyFX'),
              Tab(text: 'DollarTrack'),
              Tab(text: 'FastFX'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _QuoteTab(fetcher: fetchFromEasyFx),
            _QuoteTab(fetcher: fetchFromDollarTrack),
            _QuoteTab(fetcher: fetchFromFastFx),
          ],
        ),
      ),
    );
  }
}

class _QuoteTab extends StatefulWidget {
  const _QuoteTab({required this.fetcher});

  final Future<Quote> Function() fetcher;

  @override
  State<_QuoteTab> createState() => _QuoteTabState();
}

class _QuoteTabState extends State<_QuoteTab>
    with AutomaticKeepAliveClientMixin {
  late Future<Quote> _future;
  bool _reloading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = widget.fetcher();
  }

  Future<void> _refresh() async {
    setState(() {
      _reloading = true;
      _future = widget.fetcher();
    });
    try {
      await _future;
    } finally {
      if (mounted) setState(() => _reloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<Quote>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const _Centered(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _Centered(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Could not fetch the quote.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              final quote = snapshot.data!;
              return _Centered(child: _QuoteCard(quote: quote));
            },
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _reloading ? null : _refresh,
            tooltip: 'Refresh quote',
            child: _reloading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final formatted = quote.bid.toStringAsFixed(4);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(quote.pair, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'R\$ $formatted',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Source: ${quote.sourceName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Updated at '
              '${quote.fetchedAt.hour.toString().padLeft(2, '0')}:'
              '${quote.fetchedAt.minute.toString().padLeft(2, '0')}:'
              '${quote.fetchedAt.second.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}
