package com.search;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.Scanner;

/**
 * Created by tomas on 2/14/19.
 */
public class Test {
    public static double getAvarege(LinkedList<Integer> queue, int days) {
        int middleValue = queue.get(days / 2);
        if (days % 2 != 0) {
            if (middleValue > queue.getLast()) {
                queue.addFirst(queue.removeLast());
            }
            return queue.get(days / 2);
        } else {
            if (queue.getLast() == (queue.get((days / 2) - 1) + 1)) {
                queue.add(queue.get((days / 2) - 1), queue.pollLast());
            } else if (queue.getLast() == middleValue - 1) {
                queue.add(queue.get(days / 2), queue.pollLast());
            }
            double val = (double) queue.get(days / 2) + queue.get((days / 2) - 1);
            return val / 2;
        }
    }

    // Complete the activityNotifications function below.
    static int activityNotifications(int[] expenditure, int d) {
        int cont = 0;

        if (d >= expenditure.length) {
            return 0;
        }
        int countSort[] = new int[201];

        for (int i = 0; i < d; i++) {
            countSort[expenditure[i]]++;
        }

        for (int i = d; i < expenditure.length; i++) {
            double media +getMedian(d, countSort);
        }

        return cont;
    }

    //4
//1    //[2,5,3,6,8]
    //[2,5,3,6]
    //0,0,1,1,0,1,1-5
//2    //[2,5,3,6,8]
    //[5,3,6]
    //0,0,0,1,0,1,1
    private static double getMedian(int d, int[] countSort) {
        double median = 0;

    }

    private static final Scanner scanner = new Scanner(System.in);

    public static void main2(String[] args) throws IOException {
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(System.getenv("OUTPUT_PATH")));

        String[] nd = scanner.nextLine().split(" ");

        int n = Integer.parseInt(nd[0]);

        int d = Integer.parseInt(nd[1]);

        int[] expenditure = new int[n];

        String[] expenditureItems = scanner.nextLine().split(" ");
        scanner.skip("(\r\n|[\n\r\u2028\u2029\u0085])?");

        for (int i = 0; i < n; i++) {
            int expenditureItem = Integer.parseInt(expenditureItems[i]);
            expenditure[i] = expenditureItem;
        }

        int result = activityNotifications(expenditure, d);

        bufferedWriter.write(String.valueOf(result));
        bufferedWriter.newLine();

        bufferedWriter.close();

        scanner.close();
    }


    public static void main(String[] args) throws IOException {
        //int a[] = new int[]{1, 4, 2, 5, 6, 11, 13, 23, 9, 2, 9, 12, 0, 2, 3, 1, 10};
        int a[] = new int[]{1, 4, 2, 5, 3};
        for (Integer i : a) {
            System.out.print(i + ", ");
        }
        int ordered[] = coutingSort(a, 23);
        System.out.println();
        for (Integer i : ordered) {
            System.out.print(i + ", ");
        }
    }

    public static int[] coutingSort(int[] arr, int higherValue) {
        int[] temp = new int[higherValue + 1];
        for (int i = 0; i < arr.length; i++) {
            temp[arr[i]] += 1;
        }
        int[] sorted = new int[arr.length];
        int j = 0;
        for (int i = 0; i < temp.length; i++) {
            int x = temp[i];
            while (x-- > 0) {
                sorted[j] = i;
                j++;
            }
        }
        return sorted;
    }


}