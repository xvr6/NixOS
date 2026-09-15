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

    #nixvim seperated out into flake
    nixvim = {
      url = "git+https://forge.xvr6.dev/xvr6/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umbriel = {
      url = "github:noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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

      hosts = [
        "nixtop"
        "nixwork"
      ];

      mkHost =
        host:
        lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs self host;
          };

          modules = [
            ./hosts/${host}/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs self host;
                };
                sharedModules = [
                  inputs.umbriel.homeModules.default
                  inputs.noctalia.homeModules.default
                ];
                users.xvr6 = import ./home/${host};
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = lib.genAttrs hosts mkHost;
    };
}
