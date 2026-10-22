{
  config,
  lib,
  pkgs,
  ...
}: 
# --- Disclaimer: 
# This section was made with assistance with Claude; 
# It has been modified and maintained by xvr6.
let
  vault = config.programs.obsidian.vaults.vault.target;
  vaultPath = "${config.home.homeDirectory}/${vault}";
  jq = lib.getExe pkgs.jq;
in
{
  # Drop duplicate vault entries in obsidian.json; open ours if none is open
  home.activation.obsidianDefaultVault = lib.hm.dag.entryAfter [ "obsidian" ] (
    let
      id = builtins.substring 0 16 (builtins.hashString "md5" vault);
    in
    ''
      cfg="${config.xdg.configHome}/obsidian/obsidian.json"
      if [ -f "$cfg" ]; then
        tmp=$(mktemp)
        ${jq} --arg id "${id}" --arg path "${vaultPath}" '
          .vaults |= with_entries(select(.key == $id or .value.path != $path))
          | if any(.vaults[]; .open == true) then . else .vaults[$id].open = true end
        ' "$cfg" > "$tmp"
        run install -m 644 "$tmp" "$cfg"
        rm -f "$tmp"
      fi
    ''
  );

  # Inject sops password into LiveSync. It syncs from remoteConfigurations (not
  # couchDB_*), and stale encrypted* blobs override plaintext, so clear them.
  home.activation.obsidianLivesyncSecret = lib.hm.dag.entryAfter [ "obsidianLivesync" ] ''
    secret=/run/secrets/obsidian
    data="${vaultPath}/.obsidian/plugins/obsidian-livesync/data.json"
    if [ -r "$secret" ] && [ -f "$data" ]; then
      tmp=$(mktemp)
      ${jq} --rawfile pw "$secret" '
        ($pw | rtrimstr("\n")) as $p
        | .couchDB_PASSWORD = $p
        | .passphrase = $p
        | .encryptedCouchDBConnection = ""
        | .encryptedPassphrase = ""
        | (.couchDB_URI | capture("^(?<scheme>https?)://(?<rest>.*?)/?$")) as $u
        | .remoteConfigurations = {
            "legacy-couchdb": {
              id: "legacy-couchdb",
              name: "CouchDB Remote",
              uri: "sls+\($u.scheme)://\(.couchDB_USER | @uri):\($p | @uri)@\($u.rest)/?db=\(.couchDB_DBNAME | @uri)",
              isEncrypted: false
            }
          }
        | .activeConfigurationId = "legacy-couchdb"
      ' "$data" > "$tmp"
      run install -m 600 "$tmp" "$data"
      rm -f "$tmp"
    fi
  '';
}
