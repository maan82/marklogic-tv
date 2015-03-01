package com.marklogic.repository;

import com.marklogic.http.HttpClientFactory;
import com.ning.http.client.*;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Repository;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Enumeration;

@Repository
public class MarkLogicRepository {
    @Value("${marklogic.api.protocol}")
    private String protocol;
    @Value("${marklogic.api.port}")
    private int port;
    @Value("${marklogic.api.host}")
    private String host;

    @Autowired
    private HttpClientFactory httpClientFactory;

    public String execute(HttpServletRequest request) {
        return execute(request, null, null);
    }

    public String post(HttpServletRequest request, String postBody, String id) {
        return execute(request, postBody, id);
    }

    public String post(HttpServletRequest request, String path, String postBody, String id) {
        URI uri = createUri(path);
        RequestBuilder builder = new RequestBuilder().setMethod("POST").setURI(uri);
        builder = addPostData(request, postBody, id, builder);
        return execute(builder.build());
    }

    public String delete(HttpServletRequest request, String id) {
        return execute(request, null, id);
    }

    private String execute(HttpServletRequest request, String postBody, String id) {
        Request build = null;
        try {
            build = create(request, postBody, id).build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return execute(build);
    }

    private String execute(Request request) {
        try {
            AsyncHttpClient asyncHttpClient = httpClientFactory.create();
            ListenableFuture<Response> responseListenableFuture = asyncHttpClient.executeRequest(request);
            Response mlResponse = responseListenableFuture.get();
            String body = IOUtils.toString(mlResponse.getResponseBodyAsStream());
            if (mlResponse.getStatusCode() == HttpStatus.OK.value()) {
                return body;
            } else {
                throw new RuntimeException(body);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private RequestBuilder create(HttpServletRequest request, String body, String id) throws IOException, URISyntaxException {
        URI uri = createUri(request.getServletPath());

        RequestBuilder builder = new RequestBuilder().setMethod(request.getMethod()).setURI(uri);

        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String name = parameterNames.nextElement();
            String[] parameterValues = request.getParameterValues(name);
            for (String parameterValue : parameterValues) {
                builder = builder.addQueryParameter(name, parameterValue);
            }
        }

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            Enumeration<String> headerNames = request.getHeaderNames();
            while (headerNames.hasMoreElements()) {
                String name = headerNames.nextElement();
                Enumeration<String> headerValues = request.getHeaders(name);
                while (headerValues.hasMoreElements()) {
                    builder = builder.addHeader(name, headerValues.nextElement());
                }
            }
        }

        if ("POST".equalsIgnoreCase(request.getMethod())
            || "PUT".equalsIgnoreCase(request.getMethod())) {
            builder = addPostData(request, body, id, builder);
        }

        if ("DELETE".equalsIgnoreCase(request.getMethod())) {
            builder = builder.addHeader("accept", "application/json");
            builder = builder.addHeader("content-type", "application/json");
            builder = builder.addQueryParameter("id", id);
        }

        return builder;
    }

    private URI createUri(String path) {
        try {
            return new URI(protocol, null, host, port, path, null, null);
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    private RequestBuilder addPostData(HttpServletRequest request, String body, String id, RequestBuilder builder) {
        builder = builder.addHeader("accept", "application/json");
        builder = builder.addHeader("content-type", "application/json");
        builder = builder.addQueryParameter("id", id);
        builder = builder.setBody(body).setBodyEncoding(request.getCharacterEncoding());
        return builder;
    }

}
