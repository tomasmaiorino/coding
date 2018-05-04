package com.problems;

/**
 */
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.stream.LongStream;
import java.util.stream.Stream;

public class Problem501Future {

	private static final long MAX_NUMBERS_PER_THREAD = 100000l;

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

	public class Solution extends BaseSolution implements Callable<Long> {

		public Solution(final Stream<Long> number) {
			super(number);
		}

		@Override
		public Long call() throws Exception {
			long startTime = System.nanoTime();
			long total = countNumber(number);
			long endTime = System.nanoTime();
			System.out.println(Thread.currentThread().getName() + " operation time "
					+ ((double) (endTime - startTime) / 1000000000.0));
			return total;
		}
	}

	public List<Stream<Long>> getNumberStream(final Long numbers) {
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

	public class Result {
		Long sum = 0l;
		Long seconds = 0l;

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
			return sum;
		}
	}

	public static void main(String[] args) throws InterruptedException, ExecutionException {

		List<Stream<Long>> streams = new Problem501Future().getNumberStream(1000000l);
		Result result = new Problem501Future().new Result();
		List<Callable<Long>> tasks = new ArrayList<>();
		for (Stream<Long> items : streams) {
			tasks.add(new Problem501Future().new Solution(items));
		}
		System.out.println("calling thread");
		System.out.println(result.getSum());
	}

}
