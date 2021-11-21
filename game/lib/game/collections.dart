import 'dart:math';

extension MyRandom on Random {
  double doubleBetween(double min, double max) {
    return min + (max - min) * this.nextDouble();
  }
}

extension MyList<T> on List<T> {
  T sample([Random? random]) {
    final r = random ?? Random();
    return this[this.randomIdx(r)];
  }

  int randomIdx([Random? random]) {
    final r = random ?? Random();
    return r.nextInt(this.length);
  }

  T? popIf(bool Function(T) predicate) {
    if (this.isEmpty) {
      return null;
    }
    T first = this.first;
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
    return this.toList()..shuffle(r);
  }
}
