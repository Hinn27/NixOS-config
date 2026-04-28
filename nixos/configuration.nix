# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.home-manager.nixosModules.home-manager
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
    };
    # Opinionated: disable channels
    channel.enable = false;
  };

  # TODO: Set your hostname
  networking.hostName = "hinne";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users.hinne = {
  isNormalUser = true;
  description = "Hin";
  extraGroups = [ "wheel" "networkmanager" "docker" ]; # thêm group nếu cần
  shell = pkgs.zsh; # hoặc bash nếu bạn thích
  # optional: initialPassword = "yourpass"; # chỉ dùng lần đầu
};

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;

    grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;        # tự động tìm Windows
      device = "nodev";          # EFI mode
      # configurationLimit = 10; # giới hạn số generation để tránh đầy /boot (có thể mở sau)
    };

    efi = {
      canTouchEfiVariables = true;
      # efiSysMountPoint = "/boot";  # Comment lại vì có thể gây lỗi với một số máy
    };
  };

  # home-manager chay nhu module cua NixOS
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hinne = import ../home-manager/home.nix; # dùng hinne không cần ngoặc kép
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
# nix.settings va garbage collection
nix.settings = {
  auto-optimise-store = true;
  trusted-users = [ "root" "hinne" ];
};

nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
