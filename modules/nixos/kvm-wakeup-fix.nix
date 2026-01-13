{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.kvmWakeupFix;
in
{
  options.hardware.kvmWakeupFix = {
    enable = lib.mkEnableOption "Fix for Genesys Logic KVM Hubs preventing sleep";
  };

  config = lib.mkIf cfg.enable {
    # Ensure power management is enabled so hooks run
    powerManagement.enable = true;

    # Run this before sleep (disconnect the KVM switch)
    powerManagement.powerDownCommands = ''
      # Define Hub IDs (Genesys Logic)
      VENDOR="05e3"
      PRODUCT1="0610"
      PRODUCT2="0625"

      echo "KVM-Fix: Scanning for Hubs to disable..." | tee /dev/kmsg

      for dir in /sys/bus/usb/devices/*; do
        if [ -e "$dir/idVendor" ] && [ -e "$dir/idProduct" ]; then
          v=$(cat "$dir/idVendor")
          p=$(cat "$dir/idProduct")

          # Check for match
          if [ "$v" == "$VENDOR" ] && { [ "$p" == "$PRODUCT1" ] || [ "$p" == "$PRODUCT2" ]; }; then
            if [ -e "$dir/authorized" ]; then
              echo "KVM-Fix: Disabling Hub $v:$p at $dir" | tee /dev/kmsg
              echo "0" > "$dir/authorized"
            fi
          fi
        fi
      done
    '';

    # Run this after wake (connect back the KVM switch)
    powerManagement.resumeCommands = ''
      # Define Hub IDs (Genesys Logic)
      VENDOR="05e3"
      PRODUCT1="0610"
      PRODUCT2="0625"

      echo "KVM-Fix: Re-enabling Hubs..." | tee /dev/kmsg

      for dir in /sys/bus/usb/devices/*; do
        if [ -e "$dir/idVendor" ] && [ -e "$dir/idProduct" ]; then
          v=$(cat "$dir/idVendor")
          p=$(cat "$dir/idProduct")

          # Check for match
          if [ "$v" == "$VENDOR" ] && { [ "$p" == "$PRODUCT1" ] || [ "$p" == "$PRODUCT2" ]; }; then
            if [ -e "$dir/authorized" ]; then
              echo "KVM-Fix: Enabling Hub $v:$p at $dir" | tee /dev/kmsg
              echo "1" > "$dir/authorized"
            fi
          fi
        fi
      done
    '';
  };
}
