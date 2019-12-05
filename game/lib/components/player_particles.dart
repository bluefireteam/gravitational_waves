import 'dart:ui';

import 'package:flame/particle.dart';
import 'package:flame/particles/circle_particle.dart';
import 'package:flame/particles/moving_particle.dart';

import '../palette.dart';
import '../util.dart';

class PlayerParticles {
  Particle particle;

  PlayerParticles() {
    reset();
  }

  void update(double dt) {
    if (particle.destroy()) {
      reset();
    } else {
      particle.update(dt);
    }
  }

  void render(Canvas c) {
    if (!particle.destroy()) {
      particle.render(c);
    }
  }

  void reset() {
    Particle child = CircleParticle(
      radius: 0.45,
      paint: Paint()..color = Palette.white.color,
    );
    this.particle = Particle.generate(
      count: R.nextInt(6),
      generator: (_) {
        return MovingParticle(
          from: Offset(0, BLOCK_SIZE),
          to: Offset(-R.nextDouble() * 5, BLOCK_SIZE - 3 + R.nextDouble() * 5),
          child: child,
          lifespan: 0.05 * R.nextInt(4),
        );
      },
    );
  }
}
