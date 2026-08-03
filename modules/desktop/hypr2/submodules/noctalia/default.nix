{
  inputs,
  host,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h;
in
{
  home-manager.sharedModules = [
    (_: {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.noctalia-shell = {
        enable = true;
        settings = (builtins.fromJSON (builtins.readFile ./noctalia-settings.json));
      };
    })
  ];
}
