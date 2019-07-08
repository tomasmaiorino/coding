package com.ff.exception;

/**
 * Created by tomas on 7/8/19.
 */
public class CalculateCommissionExcepetion extends RuntimeException {

    public CalculateCommissionExcepetion(String errorMessage) {
        super(errorMessage);
    }
}
