{ config, pkgs, libs, ... }:
{
  imports = [ ./darwin-common.nix ];

  home.packages = with pkgs; [
    redis
		curl
    docker
  ];

  home.username = "jay";
  home.homeDirectory = "/Users/jay";
}
