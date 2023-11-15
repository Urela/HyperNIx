
# https://github.com/jdpedersen1/nixos/blob/main/configuration.nix
# https://github.com/notusknot/dotfiles-nix/tree/main
#Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# Use the systemd-boot EFI boot loader.
#boot.loader.systemd-boot.enable = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.efiSupport = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.loader.grub.useOSProber = true;

  networking.hostName = "Nix"; # Define your hostname.
# Pick only one of the below networking options.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

# Set your time zone.
  time.timeZone = "Africa/Johannesburg";

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,ocalhost,internal.domain";

# Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";
# console = {
#   font = "Lat2-Terminus16";
#   keyMap = "us";
#   useXkbConfig = true; # use xkbOptions in tty.
# };

# Enable the X11 windowing system.
    services.xserver = {
        layout = "us";
        xkbVariant = "";

        enable = true;
        displayManager.sddm = {
            enable = true;
            theme = "Dracula";
            autoNumlock = true;
        };

    };

    # set caps to escape in hyperland


    # For pomotroid
    #nixpkgs.config.permittedInsecurePackages = ["electron-9.4.4"];
    # Allow Unfree packages
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowInsecure = true;
    nixpkgs.config.PermittedInsecurePackages = [ "python-2.7.18.6" ];

    #programs.homegg
    programs.hyprland = {
        enable = true;
    };

    programs.hyprland.xwayland = {
        hidpi = true;
        enable = true;
    };


    # Configure keymap in X11
    
    # services.xserver.layout = "us";
    # services.xserver.xkbOptions = "eurosign:e,caps:escape";
    
    # Enable CUPS to print documents.
    services.printing = {
        enable = true;
        drivers = [ pkgs.epson-escpr ];
        browsing = true;
        defaultShared = true;
    };

    sound.enable = true;
    services.blueman.enable = true;
    services.gnome.gnome-keyring.enable = true;
    # Enable sound.
    hardware = {
       pulseaudio.enable = false;
        bluetooth.enable = true;
    };
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
    };

  hardware.cpu.intel.updateMicrocode = true;

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.urela = {
        isNormalUser = true;
        useDefaultShell = true;
        extraGroups = [ "networkmanager" "wheel" "video" "kvm" ]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
        cinnamon.nemo-with-extensions
        #vim
        # firefox-wayland
              ];
    };

    services.locate = {
        enable = true;
        locate = pkgs.mlocate;
    };

  # environment etc
  environment.etc = {
    "xdg/gtk-3.0" .source = ./gtk-3.0;
  };

  # Environment variables
    environment = {
        variables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_QPA_PLATFORM = "xcb obs";
        };
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    programs.tmux = {
      enable = true;
      shortcut = "a";

      extraConfig = ''
        set-option -g default-shell $SHELL

        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

      '';
    };

    environment.variables = { EDITOR = "vim"; };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    configure = {
    customRC = ''
           set background=dark
           syntax on                               " syntax highlighting
           set nohls                                   " no syntax highlighting on search
           set mouse=a                             " enable mouse click
           set mouse=v                             " middle-click paste with 
           set nocompatible                        " disable compatibility to old-time vi

           set wildmode=longest,list               " get bash-like tab completions

           set relativenumber                      " set number
           set pastetoggle=<F2>                    " toggle past mode

           " change pythons indenting from 4 spaces to 2 spaces
           let g:python_recommended_style = 0
           filetype plugin indent on

           " for status
           set laststatus=2
           set noshowmode
           
           set ttimeoutlen=50                      " to prevent lag when switch modes

           set tabstop=2 shiftwidth=2 expandtab    " Convert tabs to 2 spaces"
           "set noswapfile                         " disable creating swap file
           set clipboard=unnamedplus               " using system clipboard
           "set path+=**                           " For clever completion with the :find command

           set t_Co=256
           let &t_ut=""
           if exists('+termguicolors')
             let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
             let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
             set termguicolors
           endif

           require('lualine').setup()
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ 
        vimwiki 
        {
          plugin = lualine-nvim;
          type = "lua";
          configure = {
          config = ''
            local function metals_status()
              return vim.g["metals_status"] or ""
            end
            require('lualine').setup(
              {
                options = { theme = 'dracula-nvim' },
                sections = {
                  lualine_a = { 'mode' },
                  lualine_b = { 'branch', 'diff' },
                  lualine_c = { 'filename', metals_status },
                  lualine_x = {'encoding', 'filetype'},
                  lualine_y = {'progress'},
                  lualine_z = {'location'}
                }
              }
            )
          '';
          };
        } # Status Line

        ];
        opt = [];

      };
    };
  };

#
# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = with pkgs; [

      killall
      spotify
      zsh
      swww
      spotify
      discord
      simplenote
      obsidian
      playerctl
      vscode
      chromium
      zotero
      htop
      #pomotroid
      wdisplays
      imv
      w3m
      (python3.withPackages(ps: with ps; [ pandas requests numpy
          llvmlite
          requests
          tabulate
          # other python packages
          # Working with data
          # Data
          pandas
          numpy
          matplotlib
          seaborn
          #kaggle
          #phik
          tqdm
          #wandb
        
          # ML/AI
          #scikit-learn
          #xgboost
          #lightgbm
          #catboost
          torch
          torchvision
          torchaudio
        ]))

        audacity
        brave
        blueman
        cinnamon.nemo-with-extensions
        cmake
        dracula-theme
        eww-wayland
        firefox-wayland
        flameshot
        fontpreview
        fzf
        gcc
        gcolor2
        gimp
        git
        glibc
        gnome.gnome-keyring
        gnumake
        go
        gparted
        gtk3
        hugo
        hyprland
        hyprpaper
        hyprpicker
        jp2a
        kdenlive
        kitty
        libreoffice
        libsecret
        libvirt
        lsd
        lxappearance
        mailspring
        meson
        mpv
        neofetch
        ninja
        networkmanagerapplet
        obs-studio
         (pkgs.wrapOBS {
            plugins = with pkgs.obs-studio-plugins; [
                wlrobs
            ];
        })
        pavucontrol
        pipewire
        pkg-config
        polkit_gnome
        qemu_kvm
        qt5.qtwayland
        qt6.qmake
        qt6.qtwayland
        ranger
        ripgrep
        rofi-wayland
        rustup
        #scrot
        grim
        slurp 
        sddm
        shellcheck
        silver-searcher
        simplescreenrecorder
        tldr
        trash-cli
        unzip
        virt-viewer
        waybar
        wget
        wireplumber
        wl-color-picker
        wofi
        wlroots
        wl-clipboard
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-utils
        xwayland
        ydotool
        zoxide
    ];

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [  
      nerdfonts
      font-awesome
      google-fonts
  ];
  programs.zsh.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];



# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
 programs.gnupg.agent = {
   enable = true;
   enableSSHSupport = true;
 };

# List services that you want to enable:
    services.emacs = {
        enable = true;
        package = pkgs.emacs;
    };

    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        extraPortals = [ 
        pkgs.xdg-desktop-portal-gtk
        ];
    }; 
  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

  nixpkgs.overlays = [
  (self: super: {
     waybar = super.waybar.overrideAttrs (oldAttrs: {
       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
     });
   })
  ];
}
