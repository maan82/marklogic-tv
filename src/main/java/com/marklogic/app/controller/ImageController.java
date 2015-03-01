package com.marklogic.app.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.File;

@RestController
@RequestMapping(ImageController.RESOURCE_PATH)
public class ImageController {
    public static final String RESOURCE_PATH = "/app/image";
    @Value("${images_dir}")
    private String imagesDirectory;

    @RequestMapping(value = "/{id:.+}", method = RequestMethod.GET)
    @ResponseBody public FileSystemResource getPreview(@PathVariable("id") String id, HttpServletResponse response) {
        return new FileSystemResource(new File(imagesDirectory, id));
    }

}
