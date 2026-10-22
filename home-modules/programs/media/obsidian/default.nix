{ ... }:
{
  imports = [
    ./livesync.nix
    ./scripts.nix
  ];

  programs.obsidian = {
    enable = true;
    vaults.vault.target = "Documents/Vault"; # read by the other files
  };
}
