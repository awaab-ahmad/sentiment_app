import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentiment_app/utils/reusables/top_bar.dart';
import 'package:sentiment_app/utils/state/main_state.dart';

class SentimentResult extends ConsumerWidget {
  final bool isResult;
  const SentimentResult({super.key, required this.isResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final confi = ref.read(sentiState.select((v) => v.sentiment));
    final score = ref.read(sentiState.select((v) => v.score));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              const SizedBox(height: 5),
              const TopBar(text: 'Result'),
              const SizedBox(height: 10),
              const _TextBox(),
              const SizedBox(height: 10),
              const _MoodBox(),
              const SizedBox(height: 5),
              Text(confi, style: t.headlineMedium),
              const SizedBox(height: 5),
              Text(
                '${score.toStringAsFixed(0)}% confidence',
                style: t.bodyMedium,
              ),
              const SizedBox(height: 10),
              const _ProgressBar(),
              const Expanded(child: SizedBox()),
              isResult == true ? const _BottomButtons() : const SizedBox(),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextBox extends ConsumerWidget {
  const _TextBox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(sentiState.select((v) => v.text));
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final sz = MediaQuery.sizeOf(context);
    return Container(
      width: double.maxFinite,
      height: sz.height * 0.23,
      padding: const .all(15),
      decoration: BoxDecoration(
        color: c.onPrimaryContainer,
        border: BoxBorder.all(color: c.onPrimaryFixed),
        borderRadius: .circular(20),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Your Text', style: t.headlineSmall),
          const SizedBox(height: 4),
          Expanded(
            child: Card(
              color: const Color(0x00000000),
              shadowColor: const Color(0x00000000),
              margin: const EdgeInsets.all(0),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Text("\" $text\"", style: t.bodySmall),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum SentiType { positive, negative, neutral, weakPositive, weakNegative }

class _MoodBox extends ConsumerWidget {
  const _MoodBox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final senti = ref.read(sentiState.select((v) => v.sentiment));
    const imgPath = {
      'Positive': 'assets/images/smile.png',
      'Weak Positive': 'assets/images/smile.png',
      'Negative': 'assets/images/sad.png',
      'Weak Negative': 'assets/images/sad.png',
      'Neutral': 'assets/images/neutral.png',
    };

    final bg = {
      'Positive': c.error,
      'Weak Positive': c.error,
      'Negative': c.onError,
      'Weak Negative': c.onError,
      'Neutral': c.onErrorContainer,
    };

    final icoC = {
      'Positive': c.tertiary,
      'Weak Positive': c.tertiary,
      'Negative': c.onTertiary,
      'Weak Negative': c.onTertiary,
      'Neutral': c.onTertiaryContainer,
    };

    return Container(
      padding: const .all(30),
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: bg[senti], shape: .circle),
      child: Image.asset(imgPath[senti]!, color: icoC[senti]),
    );
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final value = ref.read(sentiState.select((v) => (v.score) / 100));
    final senti = ref.read(sentiState.select((v) => v.sentiment));

    final col = {
      'Positive': c.tertiary,
      'Weak Positive': c.tertiary,
      'Negative': c.onTertiary,
      'Weak Negative': c.onTertiary,
      'Neutral': c.onTertiaryContainer,
    };

    return SizedBox(
      width: 200,
      child: Card(
        clipBehavior: .antiAlias,
        margin: const .all(0),
        child: LinearProgressIndicator(
          minHeight: 6,
          value: value,
          color: col[senti],
          backgroundColor: c.onPrimary,
        ),
      ),
    );
  }
}

class _BottomButtons extends ConsumerWidget {
  const _BottomButtons();

  static ButtonStyle style(Color bg, Color bor) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: .circular(18)),
      padding: const .symmetric(vertical: 12, horizontal: 6),
      backgroundColor: bg,
      side: BorderSide(color: bor, width: 1.8),
    );
  }

  static const blcClr = Color(0xFF1E1E1E);
  static const whtClr = Color(0xFFFBF6EF);
  // making styles
  static const wht = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: .w600,
    color: Color(0xffFBF6EF),
  );

  static const blc = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: .w600,
    color: Color(0xff2E2A25),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            style: style(const Color(0xFfFFFFFF), const Color(0xFFEAE3D6)),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.copy, color: blcClr, size: 20),
                const SizedBox(width: 5),
                const Text('Copy', style: blc),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: style(const Color(0xFF2E2A25), const Color(0xFF2E2A25)),
            onPressed: () async {
              await ref.read(sentiState.notifier).addingData(context);
            },
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.save_as_sharp, color: whtClr, size: 20),
                const SizedBox(width: 5),
                Text('Save', style: wht),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
