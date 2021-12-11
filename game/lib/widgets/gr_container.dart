import 'package:flutter/widgets.dart';

import 'assets/ui_tileset.dart';
import 'spritesheet_container.dart';

class GRContainer extends StatelessWidget {
  final double? width;
  final double? height;

  final Widget child;

  final EdgeInsetsGeometry? padding;

  const GRContainer({
    required this.child,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SpritesheetContainer(
      padding: padding,
      width: width,
      height: height,
      child: child,
      spriteSheet: UITileset.tileset,
      tileSize: 16,
      destTileSize: 30,
    );
  }
}
