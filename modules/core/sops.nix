# sops-nix: secrets in ./secrets/secret.yaml, decrypted to /run/secrets/ with ~/.ssh/id_ed25519.
#   edit:    sops modules/core/secrets/secret.yaml   (from repo root)
#   declare: sops.secrets."a/b" = { };  ->  config.sops.secrets."a/b".path
#   rekey:   add new key to /.sops.yaml, then `sops updatekeys <file>`
{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  secretsFile = ./secrets/secret.yaml;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = lib.mkIf (builtins.pathExists secretsFile) {
    defaultSopsFile = secretsFile;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/home/xvr6/.ssh/id_ed25519" ]; # must be passphrase-less

    secrets = {
      obsidian.owner = "xvr6"; # LiveSync password, see obsidian/scripts.nix
    };
  };
}
