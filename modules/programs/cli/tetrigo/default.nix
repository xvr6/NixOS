{ pkgs, ... }: {
    home-manager.sharedModules = [
        (_: {
            home.packages = [
                (pkgs.tetrigo.override {
                    config = {
                        keys = {
                            force_quit = ["ctrl+c"];
                            exit = ["esc"];
                            help = ["g"];
                            submit = [" " "y" "enter"];
                            up = ["w" "j"];
                            down = ["s" "k"];
                            left = ["a" "h"];
                            right = ["d" "l"];
                            rotate_counter_clockwise = ["q" "u"];
                            rotate_clockwise = ["e" "i"];
                        };
                    };
                })
            ];
        })
    ];
}
