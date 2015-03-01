package com.marklogic.http;

import com.ning.http.client.AsyncHttpClient;
import com.ning.http.client.AsyncHttpClientConfig;
import com.ning.http.client.Realm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class HttpClientFactory {

    @Value("${marklogic.api.maxtotalconnections}")
    private int maxTotalConnections;
    @Value("${marklogic.api.username}")
    private String username;
    @Value("${marklogic.api.password}")
    private String password;
    private static AsyncHttpClient asyncHttpClient;


    public AsyncHttpClient create() {
        if (this.asyncHttpClient == null) {
            Realm realm = new Realm.RealmBuilder()
                .setPrincipal(username)
                .setPassword(password)
                .setUsePreemptiveAuth(true)
                .setScheme(Realm.AuthScheme.DIGEST)
                .build();

            AsyncHttpClientConfig.Builder builder = new AsyncHttpClientConfig.Builder()
                .setRealm(realm)
                .setAllowPoolingConnection(true)
                .setMaximumConnectionsPerHost(maxTotalConnections)
                .setMaximumConnectionsTotal(maxTotalConnections);

            this.asyncHttpClient = new AsyncHttpClient(builder.build());
        }
        return this.asyncHttpClient;
    }

}
