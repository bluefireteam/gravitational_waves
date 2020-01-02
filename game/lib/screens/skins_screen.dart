import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:gravitational_waves/game/game_data.dart';

import '../game/assets/char.dart';
import '../game/game.dart';
import '../game/skin.dart';
import '../widgets/button.dart';

class SkinsScreen extends StatefulWidget {
  final MyGame game;

  const SkinsScreen({Key key, this.game}) : super(key: key);

  @override
  _SkinsScreenState createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.game.widget,
        skins(context),
      ],
    );
  }

  Widget skins(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Row(
                  children: Skin.values.map((v) {
                    bool isSelected = GameData.instance.selectedSkin == v;
                    Sprite sprite = Char.fromSkin(v);
                    Widget widget = Flame.util.spriteAsWidget(Size(80.0, 80.0), sprite);
                    Color color = isSelected ? const Color(0xFF3333CC) : const Color(0xFF333333);
                    return Container(
                      padding: EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () async {
                          await GameData.instance.setSkin(v);
                          this.setState(() {});
                        },
                        child: Container(color: color, child: widget),
                      ),
                    );
                  }).toList(),
                ),
                PrimaryButton(
                  label: 'Back',
                  onPress: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
