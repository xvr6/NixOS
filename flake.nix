{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      url = "github:xvr6/nixvim/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # imports ./modules/ automatically
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
