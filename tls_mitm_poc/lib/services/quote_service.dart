import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http/http.dart' as http;

import '../models/quote.dart';

const _quoteUrl = 'https://economia.awesomeapi.com.br/last/USD-BRL';

Future<Quote> fetchFromEasyFx() async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(_quoteUrl));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    return Quote.fromAwesomeApiJson(
      jsonDecode(body) as Map<String, dynamic>,
      sourceName: 'EasyFX',
    );
  } finally {
    client.close(force: true);
  }
}

Future<Quote> fetchFromDollarTrack() async {
  final response = await http.get(Uri.parse(_quoteUrl));
  return Quote.fromAwesomeApiJson(
    jsonDecode(response.body) as Map<String, dynamic>,
    sourceName: 'DollarTrack',
  );
}

Future<Quote> fetchFromFastFx() async {
  final dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
  try {
    final response = await dio.get<Map<String, dynamic>>(_quoteUrl);
    return Quote.fromAwesomeApiJson(
      response.data!,
      sourceName: 'FastFX',
    );
  } finally {
    dio.close(force: true);
  }
}
