{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # Pulled from stable: unstable's handbrake ffmpeg patchset fails to apply
  # against ffmpeg 8.1.3 (A15-lavc-pgssubdec hunk). Revert once fixed upstream.
  handbrake = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.handbrake;

  wrappedHandbrake = pkgs.symlinkJoin {
    name = "ghb";
    paths = [ handbrake ];
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
