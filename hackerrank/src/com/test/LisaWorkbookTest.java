package com.test;

import org.hamcrest.core.Is;
import org.junit.Assert;
import org.junit.Test;

import com.challenges.LisaWorkbook;

public class LisaWorkbookTest {

	@Test
	public void test_workbook() {
		Assert.assertThat(LisaWorkbook.workbook(5, 3, new int[] { 4, 2, 6, 1, 10 }), Is.is(4));
		Assert.assertThat(LisaWorkbook.workbook(1, 3, new int[] { 4 }), Is.is(1));
		Assert.assertThat(LisaWorkbook.workbook(3, 3, new int[] { 1, 2, 3 }), Is.is(3));
		Assert.assertThat(
				LisaWorkbook.workbook(15, 20, new int[] { 1, 8, 19, 15, 2, 29, 3, 2, 25, 2, 19, 26, 17, 33, 22 }),
				Is.is(11));
	}
}
