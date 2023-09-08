{ config, pkgs, libs, ... }:
{
  imports = [ ./darwin-common.nix ];

  home.username = "jay.shimada";
  home.homeDirectory = "/Users/jay.shimada";
}
