{
  description = "Basic NixOS Home-Manager + Noctalia Suite Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nixvim seperated out into flake
    nixvim = {
      url = "git+https://forge.xvr6.dev/xvr6/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # - Noctalia Suite
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };
    umbriel = {
      url = "github:noctalia-dev/umbriel";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fluxer = {
      url = "github:hy4ri/fluxer-flake";
    };

    # FIXME: not actually piped to any overlay or install
    tetrigo.url = "github:Broderick-Westrope/tetrigo";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      system = "x86_64-linux";

      # Single global nixpkgs instance shared by NixOS and standalone home-manager.
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # permittedInsecurePackages = [ "ventoy-*" ];
        };
      };

      hosts = [
        "nixtop"
        "nixwork"
      ];

      mkHost =
        host:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs self host;
          };
          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./hosts/${host}/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                overwriteBackup = true;
                extraSpecialArgs = {
                  inherit inputs self host;
                };
                sharedModules = [
                  inputs.umbriel.homeModules.default
                  inputs.noctalia.homeModules.default
                ];
                users.xvr6 = import ./hosts/${host}/home.nix;
              };
            }
          ];
        };

      # Standalone home-manager entrypoint (e.g. `nh home switch`) so
      # home config can be iterated on without a full NixOS rebuild.
      mkHomeConfig =
        host:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs self host;
          };
          modules = [
            inputs.umbriel.homeModules.default
            inputs.noctalia.homeModules.default
            ./hosts/${host}/home.nix
          ];
        };
    in
    {
      nixosConfigurations = lib.genAttrs hosts mkHost;

      homeConfigurations = lib.genAttrs (map (host: "xvr6@${host}") hosts) (
        nameAndHost: mkHomeConfig (lib.removePrefix "xvr6@" nameAndHost)
      );
    };
}
