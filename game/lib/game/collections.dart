import 'dart:math';

extension MyRandom on Random {
  double doubleBetween(double min, double max) {
    return min + (max - min) * nextDouble();
  }
}

extension MyList<T> on List<T> {
  void forEachIndexed(void Function(int, T) consumer) {
    for (final pair in asMap().entries) {
      consumer(pair.key, pair.value);
    }
  }

  T sample([Random? random]) {
    final r = random ?? Random();
    return this[randomIdx(r)];
  }

  int randomIdx([Random? random]) {
    final r = random ?? Random();
    return r.nextInt(length);
  }

  T? popIf(bool Function(T) predicate) {
    if (isEmpty) {
      return null;
    }
    final first = this.first;
    if (predicate(first)) {
      return removeAt(0);
    } else {
      return null;
    }
  }
}

extension MyIterable<T> on Iterable<T> {
  List<T> shuffled([Random? random]) {
    final r = random ?? Random();
    return toList()..shuffle(r);
  }
}
