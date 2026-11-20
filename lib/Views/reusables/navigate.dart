import 'package:material_ui/material_ui.dart';

PageRouteBuilder navigate(Widget nextPage) {
  return PageRouteBuilder(
    reverseTransitionDuration: Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset(0, 0),
          ).animate(curve),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
  );
}
