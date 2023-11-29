{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    docker
    fzf
    jq
    bat
    neovim
		circleci-cli
    fd
    ripgrep
    yabai
    skhd
		curl
		gh
		httpie
    chezmoi
    tmux
    kcat
		llvm
    sccache
    bottom
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
