import 'package:flutter/material.dart';

import '../game/game.dart';
import '../widgets/gr_container.dart';
import '../widgets/label.dart';
import '../widgets/palette.dart';
import '../widgets/button.dart';

class CreditsScreen extends StatelessWidget {
  final MyGame game;

  const CreditsScreen({Key key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      game.widget,
      Column(children: [
        SizedBox(height: 40),
        Label(
            label: "Credits",
            fontSize: 28,
            fontColor: PaletteColors.blues.light),
        Expanded(
            child: Row(children: [
          Expanded(
              child: GRContainer(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                Image.asset('assets/images/fireslime-banner.png', width: 200),
                Label(
                    label: "Game made by Fireslime",
                    fontSize: 18,
                    fontColor: PaletteColors.blues.light),
                Link(link: "https://fireslime.xyz", fontSize: 18)
              ]))),
          Expanded(
              child: GRContainer(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                Label(
                    label: "Music by ©2019 Joshua McLean",
                    fontSize: 16,
                    fontColor: PaletteColors.blues.light),
                Label(
                    label: "Licensed under CC BY 4.0",
                    fontSize: 16,
                    fontColor: PaletteColors.blues.light),
                Link(link: "http://mrjoshuamclean.com", fontSize: 16),
              ]))),
        ])),
        SecondaryButton(
            label: 'Back', onPress: () => Navigator.of(context).pop()),
      ]),
    ]);
  }
}
