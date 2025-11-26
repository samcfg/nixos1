# Garcia host configuration - Hyprland desktop from nixos-a
{pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nas/security/tailscale.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages (Discord, Spotify, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # Network and Bluetooth
  networking.hostName = "Garcia";
  networking.networkmanager.enable = true;
  services.blueman.enable = true;

  # Syncthing - peer-to-peer file synchronization
  services.syncthing = {
    enable = true;
    user = "sam";
    dataDir = "/home/sam/Documents/Notes";
    configDir = "/home/sam/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
    overrideDevices = true;
    overrideFolders = true;
  };

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

  # Bootloader - UEFI mode for laptop
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # Timezone
  time.timeZone = "America/Los_Angeles";

  # Desktop services
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
    cifs-utils      # Samba client tools for mounting NAS shares
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

  system.stateVersion = "25.05";
}
