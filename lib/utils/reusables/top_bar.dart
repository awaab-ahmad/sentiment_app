import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String text;
  const TopBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
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
      ],
    );
  }
}
