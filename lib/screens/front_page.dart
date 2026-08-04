import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentiment_app/screens/history_page.dart';
import 'package:sentiment_app/utils/reusables/navigate.dart';
import 'package:sentiment_app/utils/reusables/stored_tile_model.dart';
import 'package:sentiment_app/utils/state/main_state.dart';

class FrontPage extends StatelessWidget {
  FrontPage({super.key});

  final TextEditingController input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const .symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 05),
                const _TopBar(),
                const SizedBox(height: 30),
                Text('What\'s the mood?', style: t.headlineMedium),
                Text(
                  'Paste any text and get an instant read',
                  style: t.bodyMedium,
                ),
                const SizedBox(height: 8),
                _DataField(input: input),
                const SizedBox(height: 20),
                _Button(input: input),
                const SizedBox(height: 20),
                const _RecentList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: .circular(15),
          ),
          padding: const .all(8),
          height: 45,
          width: 45,
          child: Image.asset(
            'assets/images/app_logo.png',
            color: c.onSecondary,
            height: 30,
          ),
        ),
        const SizedBox(width: 10),
        Text('MoodText', style: t.headlineMedium),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(sentiState.notifier).filterReset();
              Navigator.of(context).push(navigate(const HistoryPage()));
            });
          },
          visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
          icon: Icon(Icons.history_sharp, size: 32, color: c.onSurface),
        ),
        IconButton(
          padding: .zero,
          onPressed: () {},
          icon: Image.asset(
            color: c.onSurface,
            'assets/images/equalizer.png',
            height: 26,
          ),
        ),
      ],
    );
  }
}

class _DataField extends StatelessWidget {
  final TextEditingController input;
  const _DataField({required this.input});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: TextField(
            controller: input,
            style: t.bodyMedium,
            maxLength: 1000,
            decoration: InputDecoration(
              counterStyle: t.bodyMedium,
              contentPadding: const .symmetric(horizontal: 5, vertical: 15),
              filled: true,
              fillColor: c.onPrimaryContainer,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: c.surface),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: c.onPrimaryFixed),
              ),
              hintText: 'Type or paste a sentence, review or tweet...',
              hintStyle: t.bodyMedium,
            ),
            minLines: 7,
            maxLines: 7,
          ),
        ),
        const SizedBox(width: 1),
        Card(
          color: c.onPrimaryContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(20)),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  if (input.text.trim().isNotEmpty) input.clear();
                },
                icon: Icon(Icons.clear, color: c.surface, size: 30),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.copy, color: c.surface, size: 25),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Button extends ConsumerWidget {
  final TextEditingController input;
  const _Button({required this.input});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetch = ref.watch(sentiState.select((v) => v.isFetching));
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final sz = MediaQuery.sizeOf(context);
    if (fetch) {
      return const Center(child: CircularProgressIndicator());
    }
    return ElevatedButton(
      onPressed: () async {
        final text = input.text.trim();
        await ref.read(sentiState.notifier).apiCallPlacing(text, context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: c.secondary,
        fixedSize: Size(sz.width * 1.0, sz.height * 0.07),
        shape: RoundedRectangleBorder(borderRadius: .circular(17)),
        padding: const .symmetric(vertical: 0, horizontal: 5),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Text('Check sentiment', style: t.labelSmall),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward_outlined, size: 25, color: c.surfaceDim),
        ],
      ),
    );
  }
}

class _RecentList extends ConsumerWidget {
  const _RecentList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(sentiState.select((v) => v.recent));
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final sz = MediaQuery.sizeOf(context);
    if (list.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Recent', style: t.headlineSmall),
        SizedBox(
          height: sz.height * 0.3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final inner = list[index];
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
        ),
      ],
    );
  }
}
