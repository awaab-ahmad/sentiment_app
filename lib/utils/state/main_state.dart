import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sentiment_app/screens/result_page.dart';
import 'package:sentiment_app/utils/reusables/navigate.dart';

class SentimentMain {
  bool isFetching;
  String text;
  String sentiment;
  double score;
  Map<String, List<Map<String, dynamic>>> data;
  List<Map<String, dynamic>> recent = [];
  String filter;
  int filterIndex;

  SentimentMain({
    this.isFetching = false,
    this.text = '',
    this.sentiment = '',
    this.score = 0,
    required this.data,
    required this.recent,
    this.filter = 'All',
    this.filterIndex = 0,
  });

  SentimentMain copyWith({
    bool? isFetching,
    String? text,
    String? sentiment,
    double? score,
    Map<String, List<Map<String, dynamic>>>? data,
    List<Map<String, dynamic>>? recent,
    String? filter,
    int? filterIndex,
  }) {
    return SentimentMain(
      isFetching: isFetching ?? this.isFetching,
      text: text ?? this.text,
      sentiment: sentiment ?? this.sentiment,
      score: score ?? this.score,
      data: data ?? this.data,
      recent: recent ?? this.recent,
      filter: filter ?? this.filter,
      filterIndex: filterIndex ?? this.filterIndex,
    );
  }
}

final sentiState = StateNotifierProvider<MainSentiState, SentimentMain>(
  (ref) => MainSentiState(),
);

class MainSentiState extends StateNotifier<SentimentMain> {
  MainSentiState() : super(SentimentMain(data: {}, recent: []));

  // now making the first function for data fetching
  Future<void> apiCallPlacing(String text, BuildContext cnt) async {
    if (text.isNotEmpty) {
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        state = state.copyWith(isFetching: true);
        String callLink = 'https://api.api-ninjas.com/v1/sentiment?text=$text';
        final call = await http
            .get(
              Uri.parse(callLink),
              headers: {
                'X-Api-Key': '// You api here',
              },
            )
            .timeout(Duration(seconds: 10));
        if (kDebugMode) print(call.statusCode);
        if (call.statusCode == 200) {
          if (kDebugMode) print(call.body);
          final result = jsonDecode(call.body);
          final scr = result['score'];
          String senti = 'Positive';
          switch (result['sentiment']) {
            case 'POSITIVE':
              senti = 'Positive';
              break;
            case 'WEAK_POSITIVE':
              senti = 'Weak Positive';
              break;

            case 'NEGATIVE':
              senti = 'Negative';
              break;

            case 'WEAK_NEGATIVE':
              senti = 'Weak Negative';
              break;

            case 'NEUTRAL':
              senti = 'Neutral';
              break;
          }
          if (kDebugMode) print(senti);
          state = state.copyWith(
            text: result['text'],
            sentiment: senti,
            score: scr < 0 ? (scr * -100) : (scr * 100),
          );
        }
        state = state.copyWith(isFetching: false);
        if (!cnt.mounted) return;
        Navigator.of(cnt).push(navigate(const SentimentResult(isResult: true)));
      } catch (error) {
        if (kDebugMode) print(error);
        state = state.copyWith(isFetching: false);
      }
    } else {
      if (kDebugMode) print('The Field is empty');
    }
  }

  Future<void> addingData(BuildContext con) async {
    final rawDate = DateTime.now().toLocal();
    final formatMonth = DateFormat('MMMM dd, yyy').format(rawDate);
    final time = DateFormat('hh:mm a').format(rawDate);
    if (kDebugMode) print(formatMonth);
    if (kDebugMode) print(time);

    final newState = Map<String, List<Map<String, dynamic>>>.from(state.data);
    final newRecent = List<Map<String, dynamic>>.from(state.recent);

    newState.putIfAbsent(formatMonth, () => []);
    newState[formatMonth]!.insert(0, {
      'text': state.text,
      'sentiment': state.sentiment,
      'score': state.score,
      'time': time,
    }
    );

    if (newRecent.isEmpty) {
      newRecent.add({
        'text': state.text,
        'sentiment': state.sentiment,
        'score': state.score,
        'time': time,
      });
    } else {
      newRecent.insert(0, {
        'text': state.text,
        'sentiment': state.sentiment,
        'score': state.score,
        'time': time,
      });
    }

    if (newRecent.length > 3) {
      newRecent.removeLast();
    }
    state = state.copyWith(data: newState, recent: newRecent);
    await savingData();
    if (!con.mounted) return;
    Navigator.of(con).pop();
    if (kDebugMode) print(state.data);
  }

  void showingSavedData(String t, String sen, double scr, BuildContext con) {
    state = state.copyWith(text: t, sentiment: sen, score: scr);
    Navigator.of(con).push(navigate(const SentimentResult(isResult: false)));
  }

  void filterReset() {
    if (state.filter != 'All') {
      state = state.copyWith(filter: 'All', filterIndex: 0);
    } else {
      if (kDebugMode) print('Filter already on All');
    }
  }

  void filterIndexChanging(int index, String filter) {
    state = state.copyWith(filterIndex: index, filter: filter);
  }

  Future<void> savingData() async {
    final dataList = await Hive.openBox('allList');
    // converting the list to string first
    final convertedStringData = jsonEncode(state.data);
    final convertedStringRecent = jsonEncode(state.recent);
    dataList.put('allList', convertedStringData);
    dataList.put('recent', convertedStringRecent);
    if (kDebugMode) print('The Data is saved');
  }

  Future<void> gettingData() async {
    final storage = await Hive.openBox('allList');
    final decodeData =
        jsonDecode(storage.get('allList')) as Map<String, dynamic>;
    final decodeRecent = jsonDecode(storage.get('recent'));

    final decodedData = decodeData.map((key, value) {
      return MapEntry(key, List<Map<String, dynamic>>.from(value as List));
    });

    state = state.copyWith(data: decodedData);

    if (decodeRecent != null) {
      state = state.copyWith(
        recent: List<Map<String, dynamic>>.from(decodeRecent),
      );
    } else {
      state = state.copyWith(recent: []);
    }

    if (kDebugMode) print('Data is received');
  }
}
