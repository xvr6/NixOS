{
  config,
  lib,
  pkgs,
  ...
}:
let
  vault = config.programs.obsidian.vaults.vault.target;

  # Self-hosted LiveSync, built from release assets
  livesync = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "obsidian-livesync";
    version = "1.0.39";
    srcs = [
      (pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        hash = "sha256-ViTZ8CM8wz0lmULDl7NptVmy/q5ICQU5LuyF4Ry9qGA=";
      })
      (pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        hash = "sha256-ZP+yWYK5qpqI+I5nCHkU6xJ8ZWb+Cs4ovWqgLySMMrY=";
      })
      (pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/styles.css";
        hash = "sha256-S6AL70F+6Y2aYt2f67eS3GVVlJz8no4GlFCtaZqyufA=";
      })
    ];
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      for f in $srcs; do cp $f $out/$(stripHash $f); done
    '';
    passthru.manifestId = "obsidian-livesync";
  };

  livesyncSettings = lib.filterAttrs (_: v: v != "") {
    remoteType = ""; # "" = CouchDB
    couchDB_URI = "https://couchdb.xvr6.dev";
    couchDB_DBNAME = "xvr6";
    couchDB_USER = "xvr6";
    couchDB_PASSWORD = ""; # set from sops in scripts.nix
    encrypt = true; # passphrase = same secret

    liveSync = true;
    syncOnStart = false;
    syncOnSave = false;
    periodicReplication = false;
  };
in
{
  programs.obsidian.vaults.vault.settings.communityPlugins = [ livesync ];

  # Merge into data.json, keeping keys LiveSync writes at runtime
  home.activation.obsidianLivesync = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.hm.generators.mkImpureConfigMerger {
      inherit pkgs;
      format = "json";
      empty = "{}";
      jqOperation = "$dynamic * $static";
      path = "${config.home.homeDirectory}/${vault}/.obsidian/plugins/obsidian-livesync/data.json";
      staticSettings = (pkgs.formats.json { }).generate "livesync-data.json" livesyncSettings;
      mode = "600";
    }
  );
}
