{ pkgs, ...}: {
    services.mysql = {
        enable = true;
        package = pkgs.mariadb;
    };
    services.longview.mysqlPassword = "";

    services.postgresql = {
        enable = true;
        ensureDatabases = [ "astrodb" ];
        authentication = pkgs.lib.mkOverride 10 ''
            #type database  DBuser  auth-method
            local all       all     trust
        '';
    };

    environment.systemPackages = [
        pkgs.pgadmin4-desktopmode
    ];
}
