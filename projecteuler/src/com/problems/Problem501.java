package com.problems;

import java.security.InvalidParameterException;
import java.util.stream.LongStream;

public class Problem501 {

	public static void main(String[] args) {
		if (args == null || args.length == 0) {
			throw new InvalidParameterException("A number must be informed!");
		}
		System.out.println(new Problem501().countNumber(Long.parseLong(args[0])));
	}

	public long countNumber(long number) {

		return LongStream.rangeClosed(1, number).reduce(0l,
				(sum, n) -> isDivisibleOnlyEightTimes(n) ? sum + 1l : sum + 0l);
	}

	public boolean isDivisibleOnlyEightTimes(long number) {
		long countDivisble = 0l;
		long count = 1l;
		while (count <= number) {
			if (countDivisble > 8) {
				break;
			}
			if (number % count++ == 0) {
				countDivisble++;
			}
		}
		return countDivisble == 8l;

	}
}
