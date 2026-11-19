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