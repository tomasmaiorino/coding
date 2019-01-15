package com.quick;

/**
 * Created by tomas on 1/15/19.
 */
public class QuickSort {

    public static void main(String[] args) {
        int a[] = new int[]{4, 3, 1, 8, 6, 1, 9, 11, 4, 2, 8, 0, 3};
        for (int i : a) {
            System.out.print(i + ", ");
        }
        quickSort(a);
        System.out.println();
        for (int i : a) {
            System.out.print(i + ", ");
        }

    }

    public static void quickSort(int[] arr) {
        quickSort(arr, 0, arr.length - 1);
    }

    private static void quickSort(int[] arr, int left, int right) {

        if (left >= right) {
            return;
        }
        int pivot = arr[(left + right) / 2];
        int index = partion(arr, left, right, pivot);
        quickSort(arr, left, index - 1);
        quickSort(arr, index, right);
    }

    private static int partion(int[] arr, int left, int right, int pivot) {
        while (left <= right) {
            while (arr[left] < pivot) {
                left++;
            }
            while (arr[right] > pivot) {
                right--;
            }
            if (left <= right) {
                swap(arr, left, right);
                left++;
                right--;
            }
        }
        return left;
    }

    private static void swap(int[] arr, int left, int right) {
        int temp = arr[left];
        arr[left] = arr[right];
        arr[right] = temp;
    }


}
