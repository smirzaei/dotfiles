{ lib, pkgs, ... }:

let
    kache = lib.getExe pkgs.kache;
in
{
    home.packages = [ pkgs.kache ];

    home.sessionVariables.RUSTC_WRAPPER = kache;

    systemd.user.services.kache = {
        Unit.Description = "kache build cache daemon";
        Service = {
            ExecStart = "${kache} daemon run";
            Restart = "on-failure";
            RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
    };
}
