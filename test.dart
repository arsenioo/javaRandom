class ReversibleRandom {
  static const int _multiplier = 0x5DEECE66D;
  static const int _addend = 0xB;
  static const int _mask = 0xFFFFFFFFFFFF; // 48-bit mask

  late int _seed;

  ReversibleRandom(int seed) {
    _seed = (seed ^ _multiplier) & _mask;
  }

  @pragma('vm:prefer-inline')
  int next(int bits) {
    _seed = ((_seed * _multiplier) + _addend) & _mask;
    return _seed >> (48 - bits);
  }

  @pragma('vm:prefer-inline')
  int nextInt(int bound) {
    if ((bound & -bound) == bound) {
      return (bound * next(31)) >> 31;
    }
    int bits, val;
    do {
      bits = next(31);
      val = bits % bound;
    } while (bits - val + bound - 1 < 0);
    return val;
  }
}

void main() {
  final t = ReversibleRandom(3);
  int result = 0;
  const int count = 2000000001;
  for (int i = 0; i < count; i++) {
    result = (result + t.next(32) + t.nextInt(0x800000) + t.nextInt(9999)) & 0xFFFFFFFFFFFF;
  }
  print('${result.toRadixString(16)} $count');
}
