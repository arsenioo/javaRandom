#include <iostream>
#include <iomanip>
#include <cstdint>

class ReversibleRandom {
private:
    static const long MULTIPLIER = 0x5DEECE66D;
    static const int ADDEND = 0xB;
    static const long MASK = 0xFFFFFFFFFFFF; // 48-bit mask
    long seed;

public:
    ReversibleRandom(long s) {
        seed = (s ^ MULTIPLIER) & MASK;
    }

    inline int next(int bits) __attribute__((always_inline)) {
        seed = ((seed * MULTIPLIER) + ADDEND) & MASK;
        return seed >> (48 - bits);
    }

    inline int nextInt(int bound) __attribute__((always_inline)) {
        if ((bound & -bound) == bound) {
            return ((long)(bound)) * next(31) >> 31;
        }
        int bits, val;
        do {
            bits = next(31);
            val = bits % bound;
        } while (bits - val + bound - 1 < 0);
        return val;
    }
};

int main() {
    ReversibleRandom t(3);
    long result = 0;
    const int count = 2000000001;
    
    for (int i = 0; i < count; i++) {
	int n1 = t.next(32);
        int n2 = t.nextInt(0x800000);
        int n3 = t.nextInt(9999);
        result = (result + n1 + n2 + n3) & 0xFFFFFFFFFFFF;
    }
    
    std::cout << std::hex << result << std::dec << " " << count << std::endl;
    
    return 0;
}
