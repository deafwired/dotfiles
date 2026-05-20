{
    services.qbittorrent = {
        enable = true;
        user = "matt";
        openFirewall = true;
        webuiPort = 8080;
        serverConfig = {
                Preferences = {
                        WebUI = {
                             Username = "matt";
                             Password = "test";
                            }
                    }
            }
    };
}
