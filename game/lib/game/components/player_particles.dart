import 'dart:ui';

import 'package:flame/particle.dart';
import 'package:flame/particles/circle_particle.dart';
import 'package:flame/particles/moving_particle.dart';

import '../palette.dart';
import '../util.dart';

class PlayerParticles {
  Particle particle;
  List<Particle> jetpackParticles = [];

  PlayerParticles() {
    reset();
  }

  void update(double dt) {
    if (particle.destroy()) {
      reset();
    } else {
      particle.update(dt);
    }
    jetpackParticles.removeWhere((p) {
      p.update(dt);
      return p.destroy();
    });
  }

  void render(Canvas c, bool renderParticles) {
    if (!particle.destroy() && renderParticles) {
      particle.render(c);
    }
    jetpackParticles.forEach((p) {
      if (!p.destroy()) {
        p.render(c);
      }
    });
  }

  void jetpackBoost() {
    Particle child = CircleParticle(
      radius: 0.55,
      paint: Paint()..color = Palette.particlesJetpack.color,
    );
    this.jetpackParticles.add(
      Particle.generate(
        count: 2 + R.nextInt(6),
        generator: (_) {
          return MovingParticle(
            from: Offset(0, BLOCK_SIZE),
            to: Offset(-R.nextDouble() * 10, BLOCK_SIZE - 3 + R.nextDouble() * 5),
            child: child,
            lifespan: 0.025 * R.nextInt(4),
          );
        },
      ),
    );
  }

  void reset() {
    Particle child = CircleParticle(
      radius: 0.45,
      paint: Paint()..color = Palette.particles.color,
    );
    this.particle = Particle.generate(
      count: R.nextInt(6),
      generator: (_) {
        return MovingParticle(
          from: Offset(0, BLOCK_SIZE),
          to: Offset(-R.nextDouble() * 10, BLOCK_SIZE - 3 + R.nextDouble() * 5),
          child: child,
          lifespan: 0.025 * R.nextInt(4),
        );
      },
    );
  }
}
