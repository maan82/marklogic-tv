package com.marklogic.repository;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

@Component
public class AssetRepository {

    public void save(MultipartFile file, String directory, String fileName) throws IOException {
        byte[] bytes = file.getBytes();
        BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(new File(directory, fileName)));
        stream.write(bytes);
        stream.close();
    }

}
