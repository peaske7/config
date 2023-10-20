{ config, pkgs, libs, ... }:
{
  imports = [ ./darwin-common.nix ];

  home.packages = with pkgs; [
    redis
  ];

  home.username = "jay";
  home.homeDirectory = "/Users/jay";
}
