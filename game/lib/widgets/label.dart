import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'palette.dart';

class Label extends Text {
  Label({
    required String label,
    Color fontColor = Colors.white,
    double fontSize = 12.0,
    TextAlign? textAlign,
  }) : super(
          label,
          textAlign: textAlign,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontFamily: 'Quantum',
          ),
        );
}

class Link extends StatelessWidget {
  final String link;
  final double fontSize;

  Link({required this.link, required this.fontSize});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _onTap,
        child: Label(
          label: link,
          fontSize: fontSize,
          fontColor: PaletteColors.pinks.light,
        ),
      );

  void _onTap() async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }
}
