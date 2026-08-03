{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

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
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          input.keyboard = {
            xkb.layout = "us,ua";
          };

          layout.gaps = 5;

          binds = {
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
            "Mod+Return".spawn-sh = lib.getExe self'.packages.myKitty;
            "Mod+Q".close-window = [ ];
          };
        };
      };
    };
}
