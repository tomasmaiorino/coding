package com.search;

/**
 * Created by tomas on 1/24/19.
 */
public class BinarySearch {

    public static void main(String... args) {
        int[] arr = new int[]{1, 3, 4, 6, 8, 9, 11, 12, 15, 22, 25, 26, 30};
        System.out.println(search(arr, 8));
    }

    public static int search(int[] arr, int numberToSearch) {
        int init = 0;
        int end = arr.length - 1;
        while (init <= end) {
            int q = (init + end) / 2;
            if (numberToSearch == arr[q]) {
                return q;
            } else if (numberToSearch > arr[q]) {
                init = q + 1;
            } else {
                end = q - 1;
            }
        }
        return -1;
    }

}
