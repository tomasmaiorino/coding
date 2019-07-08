package com.ff.exception;

/**
 * Created by tomas on 7/7/19.
 */
public class ReadFileServiceException extends RuntimeException {

    public ReadFileServiceException(String errorMessage) {
        super(errorMessage);
    }
}
