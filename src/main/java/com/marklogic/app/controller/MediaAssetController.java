package com.marklogic.app.controller;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.marklogic.repository.MarkLogicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.UUID;

@RestController
@RequestMapping(MediaAssetController.RESOURCE_PATH)
public class MediaAssetController {
    public static final String RESOURCE_PATH = "/app/media_asset";
    public static final String MARKLOGIC_TV_API_ADMIN_MEDIA_PLAY_PATH = "/marklogic-tv/api/admin/media-play";

    @Value("${videos_dir}")
    private String videosDirectory;

    @Autowired
    private MarkLogicRepository repository;

    @RequestMapping(value = "/{id:.+}", method = RequestMethod.GET)
    @ResponseBody public FileSystemResource getMedia(@PathVariable("id") String id, @RequestParam("programme_id") String programmeId, HttpServletRequest request) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        String playId = UUID.randomUUID().toString();
        MediaPlay mediaPlay = new MediaPlay(playId, request.getRemoteHost(), request.getRemotePort(), programmeId);
        JsonObject jsonObject = new JsonObject(mediaPlay);
        String json = objectMapper.writer().writeValueAsString(jsonObject);
        String post = repository.post(request, MARKLOGIC_TV_API_ADMIN_MEDIA_PLAY_PATH, json, playId);
        return new FileSystemResource(new File(videosDirectory, id));
    }

    class JsonObject {
        private MediaPlay mediaPlay;

        public JsonObject(MediaPlay mediaPlay) {
            this.mediaPlay = mediaPlay;
        }

        @JsonProperty("media-play")
        public MediaPlay getMediaPlay() {
            return mediaPlay;
        }

    }

    class MediaPlay {
        private String id;
        private String ip;
        private Integer port;
        private String programmeId;

        public MediaPlay(String id, String ip, Integer port, String programmeId) {
            this.id = id;
            this.ip = ip;
            this.port = port;
            this.programmeId = programmeId;
        }

        public String getId() {
            return id;
        }

        public String getIp() {
            return ip;
        }

        public Integer getPort() {
            return port;
        }

        @JsonProperty("programme-id")
        public String getProgrammeId() {
            return programmeId;
        }
    }

}
