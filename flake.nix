{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
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
    };
}
