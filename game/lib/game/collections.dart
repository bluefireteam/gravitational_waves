import 'util.dart';

T getOrElse<T>(List<T> ts, int idx, T elseValue) {
  if (idx >= 0 && idx < ts.length - 1) {
    return ts[idx];
  }
  return elseValue;
}

T sample<T>(List<T> ts) {
  return ts[randomIdx(ts)];
}

int randomIdx<T>(List<T> ts) {
  return R.nextInt(ts.length);
}
