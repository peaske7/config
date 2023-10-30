{ config, pkgs, libs, ... }:
{
  imports = [ ./darwin-common.nix ];
  
  home.username = "jay.shimada";
  home.homeDirectory = "/Users/jay.shimada";

  home.packages = with pkgs; [
    kcat
		postgresql
  ];
}
