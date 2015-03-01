package com.marklogic.admin.common;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.marklogic.admin.model.ProgrammeWrapper;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class ProgrammeParser {

    public ProgrammeWrapper convert(String programme) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        JsonFactory factory = objectMapper.getFactory();
        JsonParser jp = factory.createParser(programme);
        return objectMapper.reader().readValue(jp, ProgrammeWrapper.class);
    }

    public String convert(ProgrammeWrapper programmeWrapper) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writeValueAsString(programmeWrapper);
    }

}
