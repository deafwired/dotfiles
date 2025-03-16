{ pkgs, ...}: {
    services.mysql = {
        enable = true;
        package = pkgs.mariadb;
    };
    services.longview.mysqlPassword = "";
}
