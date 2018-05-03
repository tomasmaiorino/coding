package com.test;

import org.hamcrest.core.Is;
import org.junit.Assert;
import org.junit.Test;

import com.lesson.Lesson4;

public class Lesson4Test {

	private Lesson4 lesson4 = new Lesson4();

	@Test
	public void test_solution_validValueGiven() {
		Assert.assertThat(lesson4.solution(new int[] { 1 }), Is.is(1));
		Assert.assertThat(lesson4.solution(new int[] { 1, 3, 6, 4, 1, 2 }), Is.is(5));
		Assert.assertThat(lesson4.solution(new int[] { 1, 2, 3 }), Is.is(4));
		Assert.assertThat(lesson4.solution(new int[] { -1, -3 }), Is.is(1));
		Assert.assertThat(lesson4.solution(new int[] { -120, -12313, -100000, -3 }), Is.is(1));
	}
}
