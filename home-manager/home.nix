# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

#   # TODO: Set your username
#   home = {
#     username = "hinNixOS";
#     homeDirectory = "/home/hinne";
#   };

  # Add stuff for your user as you see fit:
  # packages:
  home.packages = with pkgs; [
    git
    vscode
    vlc
    discord
    telegram-desktop
#     datagrip
#     podman
  ];

  # home-manager and git
  programs.home-manager.enable = true;

    programs.git = {
    enable = true;
    userName = "Hinn27";
    userEmail = "duc107243@donga.edu.vn";

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  # neovim
  programs.neovim.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
