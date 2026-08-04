import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentiment_app/screens/front_page.dart';
import 'package:sentiment_app/utils/reusables/navigate.dart';
import 'package:sentiment_app/utils/reusables/stored_tile_model.dart';
import 'package:sentiment_app/utils/reusables/top_bar.dart';
import 'package:sentiment_app/utils/state/main_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 15),
          child: Column(
            children: [
              const TopBar(text: 'History'),
              const SizedBox(height: 15),
              const _FilterTypes(),
              const SizedBox(height: 8),
              const _Data(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTypes extends ConsumerWidget {
  const _FilterTypes();

  static const List<String> moodTypes = [
    'All',
    'Positive',
    'Weak Positive',
    'Negative',
    'Weak Negative',
    'Neutral',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final filIndex = ref.watch(sentiState.select((v) => v.filterIndex));
    final sz = MediaQuery.sizeOf(context);
    return SizedBox(
      height: sz.height * 0.06,
      width: double.maxFinite,
      child: ListView.builder(
        padding: const .symmetric(vertical: 1.5),
        clipBehavior: .antiAlias,
        scrollDirection: .horizontal,
        itemCount: moodTypes.length,
        itemBuilder: (context, index) {
          bool indMatch = index == filIndex;
          return Padding(
            padding: const .symmetric(horizontal: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: .circular(15)),
                padding: const .symmetric(vertical: 8, horizontal: 12),
                backgroundColor: indMatch ? c.secondary : c.onPrimaryContainer,
                side: BorderSide(
                  color: indMatch ? c.secondary : c.onPrimaryFixed,
                ),
              ),
              onPressed: () {
                ref
                    .read(sentiState.notifier)
                    .filterIndexChanging(index, moodTypes[index]);
              },
              child: Text(
                moodTypes[index],
                style: indMatch ? t.labelSmall : t.headlineSmall,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Data extends ConsumerWidget {
  const _Data();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final filterStr = ref.watch(sentiState.select((v) => v.filter));
    final data = ref.read(sentiState.select((v) => v.data));
    if (data.isEmpty) {
      return const NoDataBox();
    }
    return Expanded(
      child: ListView.builder(
        itemCount: data.keys.toList().length,
        itemBuilder: (context, index) {
          final key = data.keys.toList()[index];
          final entries = data[key];

          final filteringList = entries!
              .where(
                (item) => filterStr == 'All' || item['sentiment'] == filterStr,
              )
              .toList();

          if (kDebugMode) print(filteringList.length);

          if (filteringList.isEmpty) {
            return Align(
              alignment: .center,
              child: Text('No relevant sentiments'),
            );
          }
          return Column(
            crossAxisAlignment: .start,
            children: [
              Text(key, style: t.headlineSmall),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteringList.length,
                itemBuilder: (context, ind) {
                  final inner = filteringList[ind];
                  final text = inner['text'];
                  final sentiment = inner['sentiment'];
                  final score = inner['score'];
                  final time = inner['time'];
                  const path = 'assets/images';
                  String img = '$path/smile.png';
                  Color icoC = c.tertiary;
                  Color icoBg = c.error;
                  switch (sentiment) {
                    case 'Positive':
                    case 'Weak Positive':
                      img = '$path/smile.png';
                      icoBg = c.error;
                      icoC = c.tertiary;
                      break;

                    case 'Negative':
                    case 'Weak Negative':
                      img = '$path/sad.png';
                      icoBg = c.onError;
                      icoC = c.onTertiary;
                      break;

                    case 'Neutral':
                      img = '$path/neutral.png';
                      icoBg = c.onErrorContainer;
                      icoC = c.onTertiaryContainer;
                      break;
                  }
                  return Tile(
                    icoBg: icoBg,
                    icoC: icoC,
                    img: img,
                    text: text,
                    time: time,
                    sentiment: sentiment,
                    f: () => ref
                        .read(sentiState.notifier)
                        .showingSavedData(text, sentiment, score, context),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class NoDataBox extends StatelessWidget {
  const NoDataBox({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: c.onErrorContainer,
              shape: .circle,
            ),
            child: Icon(Icons.message, size: 40, color: c.onSurface),
          ),
          const SizedBox(height: 15),
          Text('No history yet', style: t.displaySmall),
          const SizedBox(height: 10),
          Text(
            textAlign: .center,
            'Analyses you run will show up here \nso you can look back on them \nanytime.',
            style: t.bodyMedium,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                navigate(FrontPage()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: c.secondary,
              fixedSize: Size(210, 50),
              shape: RoundedRectangleBorder(borderRadius: .circular(15)),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/sparkler.png',
                  height: 25,
                  color: c.surfaceDim,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Analyze some text',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: .w600,
                      color: c.surfaceDim,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
