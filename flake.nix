{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/6794d064edc69918bb0fc0e0eda33ece324be17a";  # nixos-unstable with kernel 6.12.18 - before modules-shrunk bug

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, deploy-rs, ... }@inputs:
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
          sops-nix.nixosModules.sops
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

      # Deploy-rs configuration for Pi Zero 2W
      deploy.nodes.pi-zero = {
        hostname = "pi-zero";
        profiles.system = {
          sshUser = "sam";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.pi-zero;
          user = "root";
        };
      };

      # Deploy-rs checks
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
