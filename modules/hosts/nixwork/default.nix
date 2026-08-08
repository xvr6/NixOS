{ self, inputs, ... }:
{
  flake.nixosModules.core = import ../../../core;

  flake.nixosConfigurations.nixwork = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self inputs;
      host = "nixwork";
      overlays = { };
    };
    modules = [
      self.nixosModules.nixworkConfig
    ];
  };

}
