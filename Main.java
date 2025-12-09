package com.example;

class ReversibleRandom {
    static final long _multiplier = 0x5DEECE66DL;
    static final long _addend = 0xB;
    static final long _mask = 0x1000000000000L - 1;
    
    long _seed;
    
    ReversibleRandom(long seed) {
        _seed = (seed ^_multiplier) & _mask;
    }
    
    /// Advances to the next state and returns the next int
    long next(int bits) {
      _seed = ((_seed * _multiplier) + _addend) & _mask;
      return _seed >> (48 - bits);
    }
    
    /// Returns a random int in range 0 (inclusive) to bound (exclusive)
    long nextInt(int bound) {
      if ((bound & -bound) == bound) {
        // power of two optimization
        return (bound * next(31)) >> 31;
      }
    
      long bits, val;
      do {
        bits = next(31);
        val = bits % bound;
      } while (bits - val + bound - 1 < 0);
      return val;
    }    
}
    
public class Main {
    public static void main(String[] args) {
        final ReversibleRandom t = new ReversibleRandom(3);
        long result = 0;
        final int count = 2000000001;
        for (int i = 0; i < count; ++i) {
          result = (result + t.next(32) + t.nextInt(0x800000) + t.nextInt(9999)) & (0xFFFFFFFFFFFFL);
        }
        System.out.println(Long.toHexString(result) + " " + count);
    }
} 
