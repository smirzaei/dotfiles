{ config, lib, ... }:

let
  cfg = config.hardware.keychronLauncher;
in
{
  options.hardware.keychronLauncher = {
    enable = lib.mkEnableOption "udev access for Keychron Launcher";
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      ACTION!="remove", KERNEL=="hidraw*", SUBSYSTEM=="hidraw", SUBSYSTEMS=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d028", MODE="0660", TAG+="uaccess"
    '';
  };
}
