package com.service;

import com.ff.service.ReadFileService;
import com.ff.exception.ReadFileServiceException;
import org.junit.Test;

/**
 * Created by tomas on 7/7/19.
 */
public class ReadFileServiceTest {

    ReadFileService readFile = new ReadFileService();

    @Test(expected = ReadFileServiceException.class)
    public void readFile_NullPathGiven_ShouldThrowException() {

        String filePath = null;

        readFile.readFile(filePath);
    }

    @Test(expected = ReadFileServiceException.class)
    public void readFile_EmptyPathGiven_ShouldThrowException() {

        String filePath = "";

        readFile.readFile(filePath);
    }
}
