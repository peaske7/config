{ config, pkgs, libs, ... }:
{
  imports = [ ./darwin-common.nix ];

  home.username = "jay";
  home.homeDirectory = "/Users/jay";
}
