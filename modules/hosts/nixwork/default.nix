{ self, inputs, ... }:
{

  flake.nixosConfigurations.nixwork = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nixworkConfig
    ];
  };

}
