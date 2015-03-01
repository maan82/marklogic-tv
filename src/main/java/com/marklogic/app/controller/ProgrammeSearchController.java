package com.marklogic.app.controller;

import com.marklogic.repository.MarkLogicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/marklogic-tv/api/programmes")
public class ProgrammeSearchController {
    @Autowired
    private MarkLogicRepository repository;

    @RequestMapping(method = RequestMethod.GET)
    public String find(HttpServletRequest request) {
        return repository.execute(request);
    }
}
