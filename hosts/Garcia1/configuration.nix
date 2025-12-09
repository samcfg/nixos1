# Garcia host configuration - Hyprland desktop from nixos-a
{pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages (Discord, Spotify, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # Network and Bluetooth
  networking.hostName = "Garcia";
  networking.networkmanager.enable = true;
  services.blueman.enable = true;

  hardware.graphics.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
    settings.Policy = {
      AutoEnable = true;
      JustWorksAuthorize = true;
    };
  };
  hardware.enableAllFirmware = true;

  # Gaming - Steam
  programs.steam.enable = true;

  # Bootloader - BIOS mode for VM: CHANGE THIS FOR NEW MACHINE INSTALL
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Timezone
  time.timeZone = "America/Los_Angeles";

  # Desktop services
  services.desktopManager.gnome.enable = false;
  services.udisks2.enable = true;
  security.polkit.enable = true;
  services.gvfs.enable = true;

  # Swap in RAM (zram)
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "zstd";
  };

  # Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Hyprland (Wayland compositor)
  services.xserver.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
    };
  };

  # System services
  services.dbus.enable = true;

  # Login manager - SDDM (Wayland)
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Security
  security.sudo-rs.enable = true;

  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    zellij          # terminal multiplexer
    home-manager    # user environment manager
    kitty           # terminal emulator
    btop            # system monitor
    pavucontrol     # audio control
    git
    helix           # text editor
    wget
    git-lfs
    go
    os-prober       # detect other operating systems
    mako            # notifications
    pipewire
    wireplumber
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    nodejs
    util-linux
    gnome.gvfs
  ];

  # Development environment manager
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Audio - PipeWire (modern audio server)
  services.pipewire = {
    enable = true;
    pulse.enable = true;       # PulseAudio compatibility
    alsa.enable = true;         # ALSA support
    alsa.support32Bit = true;   # 32-bit app support
    jack.enable = true;         # JACK audio support
  };

  services.pipewire.wireplumber.enable = true;

  # Touchpad support
  services.libinput.enable = true;

  # GPG agent for SSH
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # User account
  users.users.sam = {
    isNormalUser = true;
    description = "sam";
    initialPassword = "1241";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "power" "docker" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.nushell;
  };

  # Default editor
  environment.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # Default shell
  users.defaultUserShell = pkgs.nushell;

  system.stateVersion = "25.11";
}
