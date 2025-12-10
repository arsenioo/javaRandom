struct ReversibleRandom {
mut:
	seed i64
}

const multiplier = i64(0x5DEECE66D)
const addend     = i64(0xB)
const mask       = i64(0xFFFFFFFFFFFF)

fn new_reversible_random(seed i64) ReversibleRandom {
	return ReversibleRandom{
		seed: (seed ^ multiplier) & mask
	}
}

fn (mut r ReversibleRandom) next(bits int) i64 {
	r.seed = (r.seed * multiplier + addend) & mask
	return r.seed >> (48 - bits)
}

fn (mut r ReversibleRandom) next_int(bound int) i64 {
	if (bound & -bound) == bound {
		return (i64(bound) * r.next(31)) >> 31
	}
	mut bits := i64(0)
	mut val := i64(0)
	for {
		bits = r.next(31)
		val = bits % bound
		if bits-val+i64(bound)-1 >= 0 {
			break
		}
	}
	return val
}

fn main() {
	mut t := new_reversible_random(3)
	mut result := i64(0)
	count := 2000000001
	for _ in 0 .. count {
		result = (result + t.next(32) + t.next_int(0x800000) + t.next_int(9999)) & mask
	}
	println('${result.hex()} $count')
}
