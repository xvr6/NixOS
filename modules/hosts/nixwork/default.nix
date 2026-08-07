{ self, inputs, ... }:
{
  flake.nixosModules.core = import ../../../core;
  flake.nixosModules.amdgpu = import ../../../core/graphics/amd.nix;

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
