package com.problems;

import java.security.InvalidParameterException;
/**
 * For a 1.000.000 input it took 1209 (20 min) seconds to process all items.
 * Operation time spent: 1209 seconds
 * Result: 224427
 */
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.stream.LongStream;
import java.util.stream.Stream;

public class Problem501Runnable {

	private static final long MAX_NUMBERS_PER_THREAD = 100000l;

	public class Result {

		private Long sum = 0l;
		private Long seconds = 0l;

		public void updateData(final Long val) {
			synchronized (this) {
				this.sum += val;
			}
		}

		public void updateData(final Long val, final Long seconds) {
			synchronized (this) {
				this.sum += val;
				this.seconds += seconds;
			}
		}

		public Long getSum() {
			return this.sum;
		}
		
		public Long getSeconds() {
			return this.seconds;
		}
	}

	public class BaseSolution {

		protected Stream<Long> number;

		protected BaseSolution(final Stream<Long> number) {
			this.number = number;
		}

		protected long countNumber(Stream<Long> number) {

			return (number).reduce(0l, (sum, n) -> isDivisibleOnlyEightTimes(n) ? sum + 1l : sum + 0l);
		}

		protected boolean isDivisibleOnlyEightTimes(long number) {
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

	public class SolutionRunnable extends BaseSolution implements Runnable {

		private Result result;

		private final CountDownLatch startSignal;
		private final CountDownLatch doneSignal;

		public SolutionRunnable(CountDownLatch startSignal, CountDownLatch doneSignal, final Stream<Long> number,
				final Result result) {
			super(number);
			this.result = result;
			this.startSignal = startSignal;
			this.doneSignal = doneSignal;
		}

		@Override
		public void run() {
			String threadName = Thread.currentThread().getName();
			try {
				startSignal.await();

				System.out.println("starting: " + threadName);

				long startTime = System.nanoTime();

				long total = super.countNumber(number);

				long endTime = System.nanoTime();
				long seconds = TimeUnit.SECONDS.convert((endTime - startTime), TimeUnit.NANOSECONDS);

				this.result.updateData(total, seconds);

				System.out.println("ending: " + threadName);

				doneSignal.countDown();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	private List<Stream<Long>> getNumberStream(final Long numbers) {
		long qt = MAX_NUMBERS_PER_THREAD;
		List<Stream<Long>> streams = new ArrayList<>();
		if (numbers <= qt) {
			streams.add(LongStream.rangeClosed(1, numbers).boxed());
		} else {
			long items = numbers / qt;
			long rest = numbers % qt;
			long c = 1;
			long v = qt;

			while (items > 0) {
				streams.add(LongStream.rangeClosed(c, v).boxed());
				if (items-- != 1) {
					c = v + 1;
					v += qt;
				}
			}
			if (rest > 0) {
				streams.add(LongStream.rangeClosed(v + 1, v + rest).boxed());
			}
		}
		return streams;

	}

	public Long countNumber(final Long number) throws InterruptedException {
		System.out.println("Starting process ...");
		long startTime = System.nanoTime();

		List<Stream<Long>> streams = new Problem501Runnable().getNumberStream(1000000l);
		CountDownLatch startSignal = new CountDownLatch(1);
		CountDownLatch doneSignal = new CountDownLatch(streams.size());

		Result result = new Problem501Runnable().new Result();
		List<Runnable> tasks = new ArrayList<>();
		for (Stream<Long> items : streams) {
			tasks.add(new Problem501Runnable().new SolutionRunnable(startSignal, doneSignal, items, result));
		}
		tasks.forEach(t -> {
			Thread thread = new Thread(t);
			thread.start();

		});

		startSignal.countDown();
		doneSignal.await();

		long endTime = System.nanoTime();
		long seconds = TimeUnit.SECONDS.convert((endTime - startTime), TimeUnit.NANOSECONDS);
		System.out.println(String.format("Operation time spent: %s seconds", seconds));
		return result.getSum();
	}

	public static void main(String[] args) throws InterruptedException {

		if (args == null || args.length == 0) {
			throw new InvalidParameterException("A number must be informed!");
		}
		System.out.println(new Problem501().countNumber(Long.parseLong(args[0])));

	}

}
