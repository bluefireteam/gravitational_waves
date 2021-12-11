import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import '../game/assets/char.dart';
import '../game/game.dart';
import '../game/game_data.dart';
import '../game/skin.dart';
import '../widgets/button.dart';
import '../widgets/gr_container.dart';
import '../widgets/label.dart';
import '../widgets/palette.dart';

class SkinsScreen extends StatefulWidget {
  const SkinsScreen({Key? key}) : super(key: key);

  @override
  _SkinsScreenState createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen> {
  Skin? _skinToBuy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: MyGame()),
        skins(context),
      ],
    );
  }

  Widget skins(BuildContext context) {
    List<Widget> children = [];

    children.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Label(
            label: 'Current gems: ${GameData.instance.coins}',
            fontColor: PaletteColors.blues.light,
          ),
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
                  Widget flameWidget = SizedBox(
                    child: SpriteWidget(
                      sprite: sprite,
                      srcSize: Vector2(100.0, 80.0),
                    ),
                    width: 100.0,
                    height: 100.0,
                  );
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
                                fontColor: PaletteColors.blues.light,
                              ),
                              right: 2.0,
                              top: 2.0,
                            ),
                          ],
                        );
                  Color? color = isSelected ? PaletteColors.blues.light : null;

                  return GRContainer(
                    padding: EdgeInsets.all(12.0),
                    width: 128,
                    height: 128,
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
    );

    final skin = _skinToBuy;
    if (skin != null) {
      children.add(
        Column(
          children: [
            Label(
              label: "Are you sure you want to buy this skin",
              fontColor: PaletteColors.blues.light,
              fontSize: 20,
            ),
            Label(
              label: "for ${skinPrice(skin)} gems?",
              fontColor: PaletteColors.blues.light,
              fontSize: 20,
            ),
            PrimaryButton(
              label: 'Yes',
              onPress: () async {
                await GameData.instance.buyAndSetSkin(skin);
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
          ],
        ),
      );
    } else {
      children.add(
        SecondaryButton(
          label: 'Back',
          onPress: () => Navigator.of(context).pop(),
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
