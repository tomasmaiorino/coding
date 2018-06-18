package com.insertion;

import java.util.concurrent.TimeUnit;

import com.base.BaseAlgo;

/**
 * O(n) - because we have to look through each element of the array.
 * <ul>
 * <li>To array of 1.000000 elements it took 537 seconds.</li>
 * </ul>
 * 
 * @author tomas.maiorino
 */
public class Insertion {

	public static void main(String[] args) {

		int[] a = BaseAlgo.generateIntArray(1_000000);
		a = new Insertion().insertionSort(a);
	}

	public int[] insertionSort(int[] a) {
		long startTime = System.nanoTime();

		for (int i = 1; i < a.length; i++) {
			for (int j = i; j > 0; j--) {
				if (a[j] < a[j - 1]) {
					int temp = a[j];
					a[j] = a[j - 1];
					a[j - 1] = temp;
				}
			}
		}

		long endTime = System.nanoTime();
		long seconds = TimeUnit.SECONDS.convert((endTime - startTime), TimeUnit.NANOSECONDS);
		System.out.println("---------------------");
		System.out.println("Time spent: " + seconds);
		System.out.println("---------------------");

		return a;
	}

}
