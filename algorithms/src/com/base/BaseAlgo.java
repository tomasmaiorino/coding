package com.base;

import java.util.Arrays;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

public class BaseAlgo {

	public static int[] generateIntArray(int length) {
		int[] a = new int[length];
		for (int i = 0; i < a.length; i++) {
			a[i] = ThreadLocalRandom.current().nextInt(0, length + 1);
		}
		return a;
	}

	public static void printArray(int[] a) {
		Arrays.stream(a).boxed().forEach(v -> System.out.println(v));
	}

	public static void printTimeSpent(long startTime) {
		long endTime = System.nanoTime();
		long seconds = TimeUnit.SECONDS.convert((endTime - startTime), TimeUnit.NANOSECONDS);

		System.out.println("---------------------");
		System.out.println("Time spent: " + seconds);
		System.out.println("---------------------");
	}

}
