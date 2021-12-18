import 'dart:ui';

import 'package:flame/game.dart';
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
    final children = <Widget>[];

    children.add(
      Column(
        children: [
          const SizedBox(height: 20),
          Label(
            label: 'Current gems: ${GameData.instance.coins}',
            fontColor: PaletteColors.blues.light,
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: Skin.values.map((v) {
                  final isOwned = GameData.instance.ownedSkins.contains(v);
                  final isSelected = GameData.instance.selectedSkin == v;
                  final price = skinPrice(v);
                  final sprite = Char.fromSkin(v);
                  final flameWidget = SizedBox(
                    child: SpriteWidget(
                      sprite: sprite,
                      srcSize: Vector2(100.0, 80.0),
                    ),
                    width: 100.0,
                    height: 100.0,
                  );
                  final widget = isOwned
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
                  final color = isSelected ? PaletteColors.blues.light : null;

                  return GRContainer(
                    padding: const EdgeInsets.all(12.0),
                    width: 128,
                    height: 128,
                    child: GestureDetector(
                      onTap: () async {
                        if (isOwned) {
                          await GameData.instance.buyAndSetSkin(v);
                          setState(() {});
                        } else if (price <= GameData.instance.coins) {
                          setState(() => _skinToBuy = v);
                        }
                      },
                      child: Container(color: color, child: widget),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );

    final skin = _skinToBuy;
    if (skin != null) {
      children.add(
        Column(
          children: [
            Label(
              label: 'Are you sure you want to buy this skin',
              fontColor: PaletteColors.blues.light,
              fontSize: 20,
            ),
            Label(
              label: 'for ${skinPrice(skin)} gems?',
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
