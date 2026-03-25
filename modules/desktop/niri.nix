{ self, inputs, ... }:
{
  #this can now be importaed as self.nixosModules.niri
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        # imports the package defined below in "perSystem" section.
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };
    };

  # this can be run independantly with nix run ~/NixOS#myNiri. Can be used for debugging and inital setup before integration into flake.
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          #startup apps
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          input.keyboard = {
            xkb.layout = "us,us";
          };

          layout.gaps = 5;
          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+O".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle"; 
            "Mod+Q".close-window = null;
          };
        };
      };
    };

}
