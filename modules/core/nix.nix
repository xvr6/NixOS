{ pkgs, lib, ... }:
{
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      download-buffer-size = 200000000;
      auto-optimise-store = true; # May make rebuilds longer but less size

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://cachix.cachix.org"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];

      use-xdg-base-directories = false;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };
  };
}
