{ inputs, pkgs, ... }:
{
	imports = [
	##./modules/home-manager/nixvim.nix
	##./modules/home-manager/shells/zsh.nix
	##./modules/home-manager/git.nix
	### TODO: ./modules/config/h-m/browsers/zen.nix
	];

  #NOTE: I now need to go through and decide what stuff i want to make into nixos modules instead of home modules, and change how flake is structured.	
	home.username = "xvr6";
	home.homeDirectory = "/home/${"xvr6"}";
	home.stateVersion = "26.05";
 

 	home.packages = with pkgs; [];
	
	#Allow home manager to self manage.
	programs.home-manager.enable = true;

	home.file = { #manually move config file from this flake to location expected by system
	# ".config/nixpkgs/config.nix".source = dotfiles/.config/nixpkgs/config.nix;
	};
			
	# home.packages = with pkgs; [
	# 	neovim
	# 	vscode-fhs
	# 	nodejs
	# 	gcc
	# 	nixpkgs-fmt
	# ];


}
