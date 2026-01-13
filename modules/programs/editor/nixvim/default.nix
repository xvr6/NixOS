{ inputs, host, pkgs, ... }:
    let
        inherit (import ../../../../hosts/${host}/variables.nix) terminal;
    in {
        home-manager.sharedModules = [
        (_: {
            imports = [
                inputs.nixvim.homeModules.nixvim
            ];
      
            programs.nixvim = {
                enable = true;
                viAlias = true;
                vimAlias = true;
      	        defaultEditor = true;
	            opts = {
                    #line numbers
                    number = true;
                    relativenumber = true;

                    #tab settings
                    tabstop = 4;
                    shiftwidth = 4;
                    softtabstop = 4;
                    expandtab = true;
                    shiftround = true;
                    autoindent = true;
                    smartindent = true;
	            };
	      
	            plugins = {
		            nvim-tree = {
                        enable = true;
                        openOnSetup = true;
                        openOnSetupFile = true;
                    };

		            web-devicons.enable = true;
                    
                    # -- Language Server Protocol --
                    lsp.enable = true;
                    lsp.servers = {
                        nixd.enable = true;
                        vue_ls.enable = true;
                        conf.enable = true;
                    };

                    # -- Cosmetic Tweaks --
                    todo-comments.enable = true;
                    lightline.enable = true;
                    highlight-colors.enable = true;
                    
                    telescope = {
                        enable = true;
                    };
	            };
            };
         
         xdg.desktopEntries = {
            "nvim" = {
              name = "Neovim wrapper";
              genericName = "Text Editor";
              comment = "Edit text files";
              exec = "${pkgs.${terminal}}/bin/${terminal} --class \"nvim-wrapper\" -e nvim %F";
              icon = "nvim";
              mimeType = [
                "text/plain"
                "text/x-makefile"
              ];
              categories = [
                "Development"
                "TextEditor"
              ];
              terminal = false; # Important: set to false since we're calling kitty directly
            };
          };
        })
      ];
    }
