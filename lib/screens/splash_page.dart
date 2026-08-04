import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentiment_app/screens/front_page.dart';
import 'package:sentiment_app/utils/reusables/navigate.dart';
import 'package:sentiment_app/utils/state/main_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sentiState.notifier).gettingData();
      Future.delayed(Duration(seconds: 2), () {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(navigate(FrontPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: [
          const _Logo(),
          const SizedBox(height: 20),
          Text('MoodText', style: t.headlineLarge),
          const SizedBox(height: 10),
          Text('Know the tone before you send it', style: t.headlineSmall),
          const SizedBox(height: 20),
          const _ProgressBar(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(20),
      height: 80,
      width: 80,
      decoration: BoxDecoration(color: c.primary, borderRadius: .circular(20)),
      child: Image.asset('assets/images/app_logo.png', color: c.onSecondary),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Center(
      child: SizedBox(
        width: 150,
        child: Card(
          margin: .zero,
          clipBehavior: .antiAlias,
          color: const Color(0x00000000),
          child: LinearProgressIndicator(
            minHeight: 5,
            color: c.primary,
            backgroundColor: c.onPrimary,
          ),
        ),
      ),
    );
  }
}
