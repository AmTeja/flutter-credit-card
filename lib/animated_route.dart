import 'package:flutter/material.dart';

class AnimatedRoute {

  Route createRoute(page, bool left) {

    return PageRouteBuilder(
        pageBuilder: (context, animation ,secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = left ? Offset(0.0, 0.1) : Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offSetAnimation = animation.drive(tween);

          return SlideTransition(position: offSetAnimation, child: child,);
        }
    );
  }

}