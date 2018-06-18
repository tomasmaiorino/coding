package com.merge;

import com.base.BaseAlgo;

/**
 * O(n log n).
 * <ul>
 * <li>To array of 1.000000 elements it took 0 seconds.</li>
 * <li>To array of 1.0000000 elements it took 2 seconds.</li>
 * <li>To array of 1.00000000 elements it took 23 seconds.</li>
 * </ul>
 * 
 * @author tomas.maiorino.
 */
public class MergeSort {

	public static void main(String[] args) {

		int[] a = BaseAlgo.generateIntArray(10000000);

		long startTime = System.nanoTime();

		a = new MergeSort().mergeSort(a);

		BaseAlgo.printTimeSpent(startTime);

		// BaseAlgo.printArray(a);
	}

	private int[] mergeSort(int a[]) {
		if (a.length <= 1) {
			return a;
		}
		int midlle = a.length / 2;
		int[] left = new int[midlle];
		int i = 0;
		for (; i < left.length; i++) {
			left[i] = a[i];
		}
		int[] right = new int[a.length - midlle];
		for (int j = 0; j < right.length; j++) {
			right[j] = a[i++];

		}
		left = mergeSort(left);
		right = mergeSort(right);
		return merge(left, right);
	}

	public int[] merge(int[] a, int[] b) {
		int[] ab = new int[a.length + b.length];
		int l = 0;
		int r = 0;
		int k = 0;

		while (l < a.length && r < b.length) {
			if (a[l] <= b[r]) {
				ab[k++] = a[l++];
			} else {
				ab[k++] = b[r++];
			}
		}

		while (l < a.length) {
			ab[k++] = a[l++];
		}

		while (r < b.length) {
			ab[k++] = b[r++];
		}

		return ab;

	}
}
