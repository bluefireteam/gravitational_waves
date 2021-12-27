enum Skin {
  ASTRONAUT,
  SECURITY,
  PINK_HAIR_PUNK,
  GREEN_HAIR_PUNK,
  ROBOT,
  HAZMAT_SUIT,
  VAMPIRE,
  RETRO_PILOT,
  ALIEN,
}

int skinPrice(Skin skin) {
  switch (skin) {
    case Skin.ASTRONAUT:
      return 0;
    case Skin.SECURITY:
    case Skin.PINK_HAIR_PUNK:
    case Skin.GREEN_HAIR_PUNK:
      return 50;
    case Skin.HAZMAT_SUIT:
    case Skin.ROBOT:
      return 150;
    case Skin.VAMPIRE:
    case Skin.RETRO_PILOT:
    case Skin.ALIEN:
      return 250;
  }
}
