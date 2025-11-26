# Pi Zero 2W - Ultra minimal wake-on-LAN trigger node
{ config, pkgs, lib, modulesPath, ... }:
# sg nix-users "nix build -L .#nixosConfigurations.pi-zero.config.system.build.sdImage --extra-experimental-features 'nix-command flakes'"
{
  imports = [
    # SD image builder for initial deployment
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    # ./hardware-configuration.nix  # Commented out - doesn't exist yet, will be generated on first boot
    # Modular configuration from tested VM setup
    ../../modules/nas/security       # SSH, firewall, Tailscale
    # ../../modules/nas/storage/samba.nix  # Disabled - not needed for wake-on-LAN node
  ];

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # SD Image settings - disable compression to reduce build overhead
  sdImage.compressImage = false;

  # Timezone
  time.timeZone = "America/Los_Angeles";

  # Hardware - Enable WiFi firmware for Broadcom chip
  hardware.enableRedistributableFirmware = true;

  # Allow unfree firmware
  nixpkgs.config.allowUnfree = true;

  # Network
  networking.hostName = "pi-zero";
  networking.wireless = {
    enable = true;
    networks = {
      "CVG" = {
        psk = "";
      };
    };
  };

  # Bootloader - SD card boot for Pi Zero 2W
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Use default kernel from sd-image-aarch64 (custom kernels unsupported per nixos-pi-zero-2 repo)
  # boot.kernelPackages = pkgs.linuxPackages_rpi02w;  # BROKEN - module closure fails

  # Fix module closure - allow missing modules (bypass ahci/dw-hdmi failures)
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // {
        allowMissing = true;
      });
    })
  ];

  # Fix initrd module issues - disable default modules
  # Pi Zero 2W uses USB OTG, not PCI-based USB controllers
  boot.initrd.includeDefaultModules = lib.mkForce false;
  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" ];

  # No GUI, no X11, no Wayland
  services.xserver.enable = false;

  # Override Samba share path (no ZFS on Pi - use regular filesystem)
  # services.samba.settings.sam.path = lib.mkForce "/home/sam";  # Disabled - Samba not enabled

  # Minimal packages for Pi functionality
  environment.systemPackages = with pkgs; [
    ethtool      # For WOL configuration
    wakeonlan    # Send WOL magic packets
    vim          # Minimal editor
    git          # Version control for pulling config updates
  ];

  # User account - minimal groups for Pi (no docker/networkmanager)
  users.users.sam = {
    isNormalUser = true;
    description = "Sam";
    initialPassword = "changeme";
    extraGroups = [ "wheel" ];  # Only sudo access needed
    shell = pkgs.bash;
  };

  # Disable documentation to save space
  documentation.enable = false;
  documentation.nixos.enable = false;

  # Minimal services only
  services.udisks2.enable = false;
  services.gvfs.enable = false;

  system.stateVersion = "25.05";
}
