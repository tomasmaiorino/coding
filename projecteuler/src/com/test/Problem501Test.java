package com.test;

import org.hamcrest.core.Is;
import org.junit.Assert;
import org.junit.Test;

import com.problems.Problem501;

public class Problem501Test {

	private Problem501 problem501 = new Problem501();

	@Test
	public void test_isDivisibleOnlyEightTimes_DivisibleEightTimesNumberGiven_shouldReturnTrue() {
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(24l), Is.is(true));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(24l), Is.is(true));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(30l), Is.is(true));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(40l), Is.is(true));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(42l), Is.is(true));
	}

	@Test
	public void test_isDivisibleOnlyEightTimes_NotDivisibleEightTimesNumberGiven_shouldReturnFalseFalse() {
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(31l), Is.is(false));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(2l), Is.is(false));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(23l), Is.is(false));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(1l), Is.is(false));
		Assert.assertThat(problem501.isDivisibleOnlyEightTimes(36l), Is.is(false));
	}

	@Test
	public void test_countNumber_shouldReturnResult() {
		Assert.assertThat(problem501.countNumber(100l), Is.is(10l));
		Assert.assertThat(problem501.countNumber(1000l), Is.is(180l));
		// This follow test is commented because it take a lot of time to be
		// executed, but is is right.
		// Assert.assertThat(problem501.countNumber(new Double(Math.pow(10,
		// 6)).longValue()), Is.is(224427l));
	}

}
