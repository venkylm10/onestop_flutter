
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class Menuoption extends StatelessWidget {
  final String name;
  final Widget? navigationwidget;
  final String? link;

  const Menuoption({Key? key, required this.name, this.navigationwidget, this.link})
      : super(key: key);

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(39, 49, 65, 1),
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          child: Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: OnestopFonts.w400.size(16).setColor(kWhite),
              )
          ),
        ),
        onTap: () {
          if (link != null) {
            launchURL(link!);
          } else {
            Navigator.of(context).push(_createSlideRoute(navigationwidget!));
          }
        }
    );
  }

  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),//duration
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:url_launcher/url_launcher.dart';


class Menuoption extends StatelessWidget {
  final String name;
  final Widget? navigationwidget;
  final String? link;
  const Menuoption({Key? key, required this.name,this.navigationwidget,this.link}) : super(key: key);

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(39, 49, 65, 1),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Center(
              child: Text(
            name,
            textAlign: TextAlign.center,
            style: OnestopFonts.w400.size(16).setColor(kWhite),
          )),
        ),
        onTap: () {
          if (link != null) {
            launchURL(link!);
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => navigationwidget!));
          }
        });
  }
}
*/


