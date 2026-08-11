{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Dendridic
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.url = "github:lassulus/wrappers";

    #nixvim seperated out into flake
    nixvim = {
      url = "github:xvr6/nixvim/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tetrigo.url = "github:Broderick-Westrope/tetrigo";
  };


  # imports ./modules/ automatically
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
