struct ReversibleRandom {
    seed: i64,
}

impl ReversibleRandom {
    const MULTIPLIER: i64 = 0x5DEECE66D;
    const ADDEND: i64 = 0xB;
    const MASK: i64 = 0xFFFFFFFFFFFF;

    fn new(seed: i64) -> Self {
        ReversibleRandom {
            seed: (seed ^ Self::MULTIPLIER) & Self::MASK,
        }
    }

    #[inline(always)]
    fn next<const BITS: i32>(&mut self) -> i32 {
        self.seed = (self
            .seed
            .wrapping_mul(Self::MULTIPLIER)
            .wrapping_add(Self::ADDEND))
            & Self::MASK;
        (self.seed >> (48 - BITS)) as i32
    }

    #[inline(always)]
    fn next_int<const BOUND: i64>(&mut self) -> i64 {
        if (BOUND & -BOUND) == BOUND {
            return (BOUND).wrapping_mul(self.next::<31>() as i64) >> 31;
        }
        let mut bits;
        let mut val;
        loop {
            bits = self.next::<31>() as i64;
            val = bits % BOUND;
            if bits - val + BOUND - 1 >= 0 {
                return val;
            }
        }
    }
}

fn main() {
    let mut t = ReversibleRandom::new(3);
    let mut result: i64 = 0;
    let count = 2000000001;

    for _ in 0..count {
        let n1 = t.next::<32>();
        let n2 = t.next_int::<0x800000>();
        let n3 = t.next_int::<9999>();
        result = (result
            .wrapping_add(n1 as i64)
            .wrapping_add(n2 as i64)
            .wrapping_add(n3 as i64))
            & 0xFFFFFFFFFFFF;
    }

    println!("{:x} {}", result, count);
}
