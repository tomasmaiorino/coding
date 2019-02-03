package com.search;

/**
 * Created by tomas on 1/24/19.
 */
public class BinarySearch {

    public static void main(String... args) {
        int[] arr = new int[]{1, 3, 4, 6, 8, 9, 11, 12, 15, 22, 25, 26, 30, 34, 35, 44, 45, 47};
        System.out.println(search(arr, 47));
        System.out.println(recursiveBinarySearch(arr, 12, 0, arr.length - 1));
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

    public static int recursiveBinarySearch(int arr[], int numberToSearch, int firstPosition, int finalPosition) {
        System.out.println(firstPosition + " ..... " + finalPosition);
        int point = (firstPosition + finalPosition) / 2;
        if (firstPosition > finalPosition) {
            return -1;
        } else {
            if (arr[point] == numberToSearch) {
                return point;
            } else if (numberToSearch > arr[point]) {
                firstPosition = point + 1;
            } else {
                finalPosition = point - 1;
            }
            return recursiveBinarySearch(arr, numberToSearch, firstPosition, finalPosition);
        }
    }

}
