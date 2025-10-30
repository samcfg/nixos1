{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      system-arm = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-arm = import nixpkgs {
        system = system-arm;
        config.allowUnfree = true;
      };
    in
    {
      # Host with integrated home-manager (current working setup)
      nixosConfigurations.sam = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/sam/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      # Garcia host with standalone home-manager (testing Hyprland)
      nixosConfigurations.Garcia = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/Garcia/configuration.nix
          # NO home-manager module - uses standalone below
        ];
      };

      # Standalone home-manager configuration (for Garcia)
      homeConfigurations."Garcia" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/Garcia/home.nix ];
      };

      # Pi Zero 2W - Ultra minimal wake-on-LAN node
      nixosConfigurations.pi-zero = nixpkgs.lib.nixosSystem {
        system = system-arm;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/pi-zero/configuration.nix
        ];
      };

      # NAS Server - Main storage and services host (physical hardware)
      nixosConfigurations.nas-server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nas-server/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };

      # NAS Server VM - Testing configuration before physical deployment
      nixosConfigurations.nas-server-vm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nas-server-vm/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
    };
}
