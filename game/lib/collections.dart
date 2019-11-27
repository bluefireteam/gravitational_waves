import 'dart:math' as math;

T getOrElse<T>(List<T> ts, int idx, T elseValue) {
  if (idx >= 0 && idx < ts.length - 1) {
    return ts[idx];
  }
  return elseValue;
}

T sample<T>(List<T> ts) {
  final r = math.Random();
  return ts[r.nextInt(ts.length)];
}