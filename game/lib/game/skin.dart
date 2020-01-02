enum Skin {
  ASTRONAUT, SECURITY
}

int skinPrice(Skin skin) {
  switch (skin) {
    case Skin.ASTRONAUT: return 0;
    case Skin.SECURITY: return 10;
  }
  throw 'Unknown skin $skin!';
}