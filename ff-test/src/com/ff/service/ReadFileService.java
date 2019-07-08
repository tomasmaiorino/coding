package com.ff.service;

import com.ff.exception.ReadFileServiceException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Created by tomas on 7/7/19.
 */
public class ReadFileService {


    final String READ_FILE_INVALID_PARAM_MESSAGE_ERROR = "The filePath must not be null!";

    public Set<String> readFile(final String filePath) {


        if (Objects.isNull(filePath) || filePath.trim().isEmpty()) {
            throw new ReadFileServiceException(READ_FILE_INVALID_PARAM_MESSAGE_ERROR);
        }

        return getFile(filePath).collect(Collectors.toSet());
    }

    private Stream<String> getFile(final String filePath) {
        try {
            return Files.lines(Paths.get(filePath));
        } catch (IOException e) {
            throw new ReadFileServiceException(e.getMessage());
        }
    }
}
