package com.marklogic.admin.common;

import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class IdGenerator {

    public String getUUID() {
        return UUID.randomUUID().toString();
    }
}
