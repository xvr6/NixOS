{ config, lib, ... }:
# Wipes Electron caches on every home switch; caches left by an older Electron blank windows after updates.
# Apps are found by their "Code Cache"/GPUCache dirs; running apps should be restarted afterwards.
let
  caches = [
    "Cache"
    "Code Cache"
    "CachedData"
    "GPUCache"
    "GPUPersistentCache"
    "DawnGraphiteCache"
    "DawnWebGPUCache"
    "GrShaderCache"
    "ShaderCache"
  ];
  rmCaches = lib.concatMapStringsSep " " (c: ''"$root"/${lib.escapeShellArg c}'') caches;
in
{
  home.activation.clearElectronCaches = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for base in "${config.xdg.configHome}" "$HOME"/.var/app/*/config; do
      [ -d "$base" ] || continue
      find "$base" -mindepth 2 -maxdepth 3 -type d \( -name "Code Cache" -o -name GPUCache \) -prune -printf '%h\0' \
        | sort -zu \
        | while IFS= read -r -d "" root; do
            [ "''${root##*/}" = GPUPersistentCache ] && continue
            # Chromium browsers keep profiles under Default/; leave them alone
            { [ -f "$root/Default/Preferences" ] || [ -f "$root/../Default/Preferences" ]; } && continue
            verboseEcho "Clearing Electron caches in $root"
            run rm -rf ${rmCaches}
          done
    done
  '';
}
