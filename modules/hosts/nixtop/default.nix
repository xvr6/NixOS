{ self, inputs, ... }:
{
  flake.nixosModules.core = import ../../../core;

  flake.nixosConfigurations.nixtop = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self inputs;
      host = "nixtop";
      overlays = { };
    };
    modules = [
      self.nixosModules.nixtopConfig
    ];
  };

}
