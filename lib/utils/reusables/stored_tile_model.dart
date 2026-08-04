import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Color icoBg;
  final Color icoC;
  final String img;
  final String text;
  final String sentiment;
  final String time;
  final Function() f;
  const Tile({
    super.key,
    required this.icoBg,
    required this.icoC,
    required this.img,
    required this.text,
    required this.time,
    required this.sentiment,
    required this.f,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Container(
      margin: const .symmetric(vertical: 3),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        color: c.onPrimaryContainer,
        border: BoxBorder.all(color: c.onPrimaryFixed),
      ),
      child: Material(
        color: const Color(0x00000000),
        shape: RoundedRectangleBorder(borderRadius: .circular(20)),
        clipBehavior: .antiAlias,
        child: ListTile(
          onTap: () {
            f();
          },
          contentPadding: const .symmetric(vertical: 0, horizontal: 10),
          leading: Container(
            padding: const .all(10),
            margin: const .all(5),
            decoration: BoxDecoration(
              color: icoBg,
              borderRadius: .circular(15),
            ),
            child: Image.asset(img, color: icoC),
          ),
          title: Text(
            maxLines: 1,
            overflow: .ellipsis,
            text,
            style: t.bodySmall,
          ),
          subtitle: Text('$time · $sentiment', style: t.bodyMedium),
        ),
      ),
    );
  }
}
