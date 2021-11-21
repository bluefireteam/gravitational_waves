import 'dart:ui';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';

import '../palette.dart';
import '../util.dart';

class PlayerParticles {
  late Particle particle;
  late List<Particle> jetpackParticles = [];

  PlayerParticles() {
    reset();
  }

  void update(double dt) {
    if (particle.shouldRemove) {
      reset();
    } else {
      particle.update(dt);
    }
    jetpackParticles.removeWhere((p) {
      p.update(dt);
      return p.shouldRemove;
    });
  }

  void render(Canvas c, bool renderParticles) {
    if (!particle.shouldRemove && renderParticles) {
      particle.render(c);
    }
    jetpackParticles.forEach((p) {
      if (!p.shouldRemove) {
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
                from: Vector2(0, BLOCK_SIZE),
                to: Vector2(
                  -R.nextDouble() * 10,
                  BLOCK_SIZE - 3 + R.nextDouble() * 5,
                ),
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
          from: Vector2(0, BLOCK_SIZE),
          to: Vector2(
            -R.nextDouble() * 10,
            BLOCK_SIZE - 3 + R.nextDouble() * 5,
          ),
          child: child,
          lifespan: 0.025 * R.nextInt(4),
        );
      },
    );
  }
}
