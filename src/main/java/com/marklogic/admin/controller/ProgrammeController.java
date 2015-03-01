package com.marklogic.admin.controller;

import com.marklogic.admin.common.IdGenerator;
import com.marklogic.admin.common.ProgrammeParser;
import com.marklogic.admin.model.ProgrammeWrapper;
import com.marklogic.app.controller.ImageController;
import com.marklogic.app.controller.MediaAssetController;
import com.marklogic.repository.AssetRepository;
import com.marklogic.repository.MarkLogicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@RestController
@RequestMapping("/marklogic-tv/api/admin/programmes")
public class ProgrammeController {
    @Value("${videos_dir}")
    private String videosDirectory;

    @Value("${images_dir}")
    private String imagesDirectory;

    @Autowired
    private MarkLogicRepository repository;

    @Autowired
    private IdGenerator idGenerator;

    @Autowired
    private ProgrammeParser programmeParser;

    @Autowired
    private AssetRepository assetRepository;

    @RequestMapping(method = RequestMethod.POST)
    public  @ResponseBody String  add(@RequestParam("file") MultipartFile[] files, @RequestParam("programme") String programme, HttpServletRequest request) throws IOException {
        String uuid = idGenerator.getUUID();
        ProgrammeWrapper programmeWrapper = programmeParser.convert(programme);
        programmeWrapper.getProgramme().setId(uuid);
        for(MultipartFile file:files) {
            if (!file.isEmpty()) {
                try {
                    String mediaName = uuid + file.getOriginalFilename();
                    if (file.getContentType().toLowerCase().contains("image")) {
                        programmeWrapper.getProgramme().setImage(ImageController.RESOURCE_PATH + "/" + mediaName);
                        assetRepository.save(file, imagesDirectory, mediaName);
                    } else {
                        programmeWrapper.getProgramme().setMedia(MediaAssetController.RESOURCE_PATH + "/" +mediaName);
                        assetRepository.save(file, videosDirectory, mediaName);
                    }
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }

        String post = repository.post(request, programmeParser.convert(programmeWrapper), uuid);
        return post;
    }

    @RequestMapping(method = RequestMethod.GET)
    public String find(HttpServletRequest request) {
        return repository.execute(request);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public void deleteItem(@PathVariable String id, HttpServletRequest request) {
        repository.delete(request, id);
    }

    public void setVideosDirectory(String videosDirectory) {
        this.videosDirectory = videosDirectory;
    }

    public void setImagesDirectory(String imagesDirectory) {
        this.imagesDirectory = imagesDirectory;
    }
}
