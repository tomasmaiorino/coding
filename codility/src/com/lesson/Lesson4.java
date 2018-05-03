package com.lesson;

import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;

public class Lesson4 {

	public int solution(int[] A) {
		if (A.length == 1) {
			if (A[0] <= 0 || A[0] == 1) {
				return 1;
			} else if (A[0] > 0) {
				return A[0] - 1;
			}
		}
		// To sort the numbers and removed the duplicated one.
		Set<Integer> numbers = Arrays.stream(A).boxed().sorted().collect(Collectors.toSet());
		Integer[] arr = new Integer[numbers.size()];
		arr = numbers.toArray(arr);

		if (arr[arr.length - 1] <= 0) {
			return 1;
		}
		for (int i = 0; i < arr.length - 1; i++) {
			if (arr[i] + 1 != arr[i + 1]) {
				return arr[i] + 1 == 0 ? 1 : arr[i] + 1;
			}
		}
		return arr[arr.length - 1] + 1;

	}
}
