{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    # development
    docker
    fzf
    jq
    bat
    neovim
		circleci-cli

    # productivity
    fd
    ripgrep
    yabai
    skhd
		curl
  ];

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  # uncomment once zshrc migration is complete
  # programs.zsh = {
  #   enable = true;
  #   autocd = true;
  #   enableAutosuggestions = true;
  #   enableCompletion = true;
  # };
}
