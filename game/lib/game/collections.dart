import 'dart:math';

extension MyRandom on Random {
  double doubleBetween(double min, double max) {
    return min + (max - min) * this.nextDouble();
  }
}

class Pair<T1, T2> {
    final T1 first;
    final T2 second;
    Pair(this.first, this.second);
}

extension MyList<T> on List<T> {
  T getOrElse(int idx, T elseValue) {
    if (idx >= 0 && idx < this.length - 1) {
      return this[idx];
    }
    return elseValue;
  }

  T sample([Random random]) {
    final r = random ?? Random();
    return this[this.randomIdx(r)];
  }

  int randomIdx([Random random]) {
    final r = random ?? Random();
    return r.nextInt(this.length);
  }

  T popIf(bool Function(T) predicate) {
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

  T firstOrNull(bool Function(T) predicate) {
    return this.firstWhere(predicate, orElse: () => null);
  }

  List<T> shuffled([Random random]) {
    final r = random ?? Random();
    return this.toList()..shuffle(r);
  }

  Map<K, V> associate<K, V>({
    K Function(T) keyMapper,
    V Function(T) valueMapper,
  }) {
    keyMapper ??= (e) => e as K;
    valueMapper ??= (e) => e as V;
    Map<K, V> map = {};
    for (final t in this) {
      final key = keyMapper(t);
      if (map.containsKey(key)) {
        throw 'Invalid keyMapper, duplicate found for key $key';
      }
      map[key] = valueMapper(t);
    }
    return map;
  }
}
