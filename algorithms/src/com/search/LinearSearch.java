package com.search;

/**
 * Created by tomas on 2/3/19.
 */
public class LinearSearch {


    public static void main(String... args) {
        int arr[] = new int[]{
                10, 3, 5, 6, 8, 2, 4, 1, 665, 2, 4, 6, 1, 4, 8, 99, 12, 13, 14, 15, 16, 23, 34, 23, 5
        };

        //int position = linearSearch(arr, 43);
        int position = recursiveLinearSearch(arr, 1221, 0);

        System.out.println("Item found at " + position + " position.");
    }

    public static int linearSearch(int[] arr, int val) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == val) {
                return i;
            }
        }
        return -1;
    }

    public static int recursiveLinearSearch(int[] arr, int val, int position) {
        if (position > arr.length - 1) {
            return -1;
        } else if (arr[position] == val) {
            return position;
        } else {
            return recursiveLinearSearch(arr, val, position + 1);
        }
    }
}
