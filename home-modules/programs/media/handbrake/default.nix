{
  config,
  lib,
  pkgs,
  ...
}:
let
  wrappedHandbrake = pkgs.symlinkJoin {
    name = "ghb";
    paths = [ pkgs.handbrake ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/ghb \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
      wrapProgram $out/bin/HandBrakeCLI \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
    '';
  };

in
{
  home.packages = [
    wrappedHandbrake
  ];
}
