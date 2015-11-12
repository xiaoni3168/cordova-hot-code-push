package com.nordnetab.chcp.main.network;

import com.nordnetab.chcp.main.config.ApplicationConfig;

/**
 * Created by Nikolay Demyankov on 24.07.15.
 * <p/>
 * Helper class to download application config from the server.
 *
 * @see ApplicationConfig
 * @see DownloadResult
 */
public class ApplicationConfigDownloader extends JsonDownloader<ApplicationConfig> {

    /**
     * Class constructor
     *
     * @param url url from where to download application config
     */
    public ApplicationConfigDownloader(String url, String token) {
        super(url, token);
    }

    @Override
    protected ApplicationConfig createInstance(String json) {
        return ApplicationConfig.fromJson(json);
    }
}
