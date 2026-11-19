import 'package:flutter_riverpod/legacy.dart';
import 'package:sentiment_app/Controllers/state/main_state.dart';
import 'package:sentiment_app/Model/main_model.dart';

final sentiState = StateNotifierProvider<MainSentiState, SentimentMain>(
  (ref) => MainSentiState(),
);
