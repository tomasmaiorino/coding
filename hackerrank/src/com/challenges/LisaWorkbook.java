package com.challenges;

public class LisaWorkbook {

	public static int workbook(int n, int k, int[] arr) {
		// Complete this function
		int pagesCount = 1;
		int special = 0;
		for (int chapter = 0; chapter < n; chapter++) {
			int chapterPageCount = k;
			for (int problem = 1; problem <= arr[chapter]; problem++) {
				if (problem == pagesCount) {
					special++;
				}
				if (problem < arr[chapter] && problem == chapterPageCount) {
					pagesCount++;
					chapterPageCount += k;
				}
			}
			pagesCount++;
		}
		return special;
	}

}
