package com.challenges;

import java.io.IOException;

public class KindergartenAdventures {

	/*
	 * Complete the solve function below.
	 */
	static int solve(int[] t) {
		/*
		 * Return the ID
		 */
		int higherNumber = 0;
		int higherPosition = 0;
		int smallesNumber = 0;
		int smallestPosition = -1;
		for (int i = 0; i < t.length; i++) {
			if (t[i] > higherNumber) {
				higherNumber = t[i];
				higherPosition = i;
			}
			if (t[i] < smallesNumber || (smallesNumber == 0 && smallestPosition == -1)) {
				smallesNumber = t[i];
				smallestPosition = i;
			}
		}
		if (smallestPosition < higherPosition) {
			smallestPosition = -1;
			smallesNumber = 0;
			for (int i = 0; i < higherPosition; i++) {
				if (t[i] < smallesNumber || (smallesNumber == 0 && smallestPosition == -1)) {
					smallesNumber = t[i];
					smallestPosition = i;
				}
			}
			return smallestPosition + 1;
		} else {
			return smallestPosition + 1;
		}
	}

	public static void main(String[] args) throws IOException {
		System.out.println(solve(new int[] { 1, 0, 0, 24242, 423424223, 4242340, 424230234, 0 }));
	}
}
