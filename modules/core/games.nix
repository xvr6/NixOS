{ pkgs, lib, ... }: {

    nixpkgs.config.allowUnfreePredicate =
        pkg: builtins.elem (lib.getName pkg) [
           "steam"
            "steam-unwrapped"
        ];

    environment.systemPackages = with pkgs; [
        bottles
        prismlauncher

        wineWowPackages.staging
        # balatro # used to be a thing? look into how declaratively importing steam games work.
        lua
        love # Compat for LOVE (engine) based games

        mangohud
        gamemode
        gamescope
    ];
   
    programs = {
        gamemode = {
            enable = true;
            settings = {
                # Disable ioprio optimisation: on some setups GameMode can't reliably
                # apply or verify ioprio, causing noisy "ioprio was (0) but we expected" logs.
                general.ioprio = 0;

                # Steam registers GameMode from its launch wrapper first, then execs the
                # real game; blacklisting the wrapper prevents duplicate-client warnings.
                filter.blacklist = [ "steam-launch-wrapper" ];
            };
        };
        steam = { 
            enable = true;
            package = pkgs.steam.override {
                extraPkgs = (pkgs: with pkgs; [
                    # additional pacdkages...
                    # e.g. some games require python3
                    gamemode
                    love
                ]);
            };
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
    };
}


#     gamescopeSession = {
#       enable = true;
#       args = [
#         "--rt"
#         "--expose-wayland"
#         # "--immediate-flips" # Tearing and low input lag
#         # "--adaptive-sync"  # G-Sync/FreeSync
#       ];
#     };
#       };
#   };
#  gamescope = {
#     enable = true;
#     capSysNice = true;
#     package = pkgs.gamescope;
#     args = [
#       "--rt"
#       "--expose-wayland"

#       # experimental
#       # "--immediate-flips"
#     ];
#   };
# };
#}
