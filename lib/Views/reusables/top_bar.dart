import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentiment_app/Controllers/state/providers.dart';

class TopBar extends ConsumerWidget {
  final String text;
  const TopBar({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final myText = ref.read(sentiState.select((v) => v.sentiment));
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_back_ios, size: 25, color: c.surface),
        ),
        Text(text, style: t.headlineMedium),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: myText));
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
            }
          },
          icon: Icon(Icons.copy, color: c.surface),
        ),
      ],
    );
  }
}
