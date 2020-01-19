import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../game/game_data.dart';

import '../game/assets/char.dart';
import '../game/game.dart';
import '../game/skin.dart';
import '../widgets/button.dart';
import '../widgets/gr_container.dart';
import '../widgets/palette.dart';
import '../widgets/label.dart';

class SkinsScreen extends StatefulWidget {
  final MyGame game;

  const SkinsScreen({Key key, this.game}) : super(key: key);

  @override
  _SkinsScreenState createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen> {
  Skin _skinToBuy;

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
    List<Widget> children = [];

    children.add(Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Label(
              label: 'Current gems: ${GameData.instance.coins}',
              fontColor: PaletteColors.blues.light),
          SizedBox(height: 20),
          Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: Skin.values.map((v) {
                  bool isOwned = GameData.instance.ownedSkins.contains(v);
                  bool isSelected = GameData.instance.selectedSkin == v;
                  final price = skinPrice(v);
                  Sprite sprite = Char.fromSkin(v);
                  Widget flameWidget =
                      Flame.util.spriteAsWidget(Size(100.0, 80.0), sprite);
                  Widget widget = isOwned
                      ? flameWidget
                      : Stack(
                          children: [
                            Opacity(
                              opacity: 0.3,
                              child: flameWidget,
                            ),
                            Positioned(
                              child: Label(
                                  label: '$price gems',
                                  fontColor: PaletteColors.blues.light),
                              right: 2.0,
                              top: 2.0,
                            ),
                          ],
                        );
                  Color color = isSelected ? PaletteColors.blues.light : null;

                  return GRContainer(
                    padding: EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (isOwned) {
                          await GameData.instance.buyAndSetSkin(v);
                          setState(() {});
                        } else if (price <= GameData.instance.coins) {
                          this.setState(() {
                            _skinToBuy = v;
                          });
                        }
                      },
                      child: Container(color: color, child: widget),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    ));

    if (_skinToBuy != null) {
      children.add(Column(children: [
        Label(
            label: "Are you sure you want to buy this skin",
            fontColor: PaletteColors.blues.light,
            fontSize: 20),
        Label(
            label: "for ${skinPrice(_skinToBuy)} gems?",
            fontColor: PaletteColors.blues.light,
            fontSize: 20),
        PrimaryButton(
          label: 'Yes',
          onPress: () async {
            await GameData.instance.buyAndSetSkin(_skinToBuy);
            setState(() {
              _skinToBuy = null;
            });
          },
        ),
        SecondaryButton(
          label: 'Cancel',
          onPress: () => setState(() {
            _skinToBuy = null;
          }),
        )
      ]));
    } else {
      children.add(SecondaryButton(
        label: 'Back',
        onPress: () => Navigator.of(context).pop(),
      ));
    }

    return Align(
      alignment: Alignment.center,
      child: Column(
        children: children,
      ),
    );
  }
}
