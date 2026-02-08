{ host, inputs, ... }:
{
  # Apply upstream overlays by including them in `nixpkgs.overlays`.
  tetrigo = inputs.tetrigo.overlays.default;

  # Overlay custom derivations into nixpkgs so you can use pkgs.<name>
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit host;
    };

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    # nur = inputs.nur.overlays.default;
    # unstable = import inputs.nixpkgs-unstable {
    #     config.allowUnFree = true;
    # };
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
    vesktop = prev.vesktop.override {
      withSystemVencord = false;
      withMiddleClickScroll = true;
    };
    discord = prev.discord.override {
      withVencord = true;
      withOpenASAR = true;
      enableAutoscroll = true;
    };
  };
}
