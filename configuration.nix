# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports for chromecasting 
  #networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];

  # Docker/Podman
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
  };
  #Make sure docker can use unprivileged ports from 0
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;


  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable bluetooth 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # these 2 options below were not mentioned in wiki
  hardware.bluetooth.powerOnBoot = false;
  
  # VPN 
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  #Setting up fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      jetbrains-mono
      font-awesome
      roboto
      liberation_ttf
      dejavu_fonts
      cantarell-fonts
      noto-fonts
      noto-fonts-cjk-sans        # Optional: for Chinese/Japanese/Korean
      noto-fonts-emoji      # Optional: for emoji support
      pkgs.nerd-fonts.hack
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code

    ];
  };


  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.oscar = {
    isNormalUser = true;
    description = "oscar";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "oscar";

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

    # Enable NVIDIA drivers
    services.xserver.videoDrivers = ["amdgpu" "nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = true;
      nvidiaSettings = true;
      open = false;

      prime = {
        offload.enable = true;
        # Match your GPU bus IDs
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
    };
  };

   # Hyprland
   programs.hyprland.enable = true;
   
   services.greetd = {
    enable = true;
      settings.default_session = {
        command = "Hyprland";
        user = "oscar";
      };
   };

   environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GL_VRR_ALLOWED = "1"; # If you want VRR
  };   
  
  # File Explorer
  programs.thunar.enable = true;



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   # Linux Utils 
   util-linux  # for lsblk
   usbutils    # for lsusb
   udisks 
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   curl
   file
   unzip
   gzip
   gnutar
   htop
   discord
   chromium
   obsidian
   bmon
   mullvad-browser
   # Development
   git
   gh
   vscode
   go
   ruby
   gcc
   libffi
   zlib
   openssl
   python3
   gnumake
   docker-compose
   ansible
   docker
   #Package for identifi BUS_ID of GPU:s
   lshw
   pciutils
   #Hyprland Utils
   hyprland
   waybar
   rofi-wayland
   kitty
   nwg-look
   brightnessctl
   bluetui
   pavucontrol
   wofi 
   networkmanager
   hyprpaper
   swww
   numix-cursor-theme
   htop
   lolcat
   cowsay
   libnotify
   #Media
   vlc
   gimp
   mpv
   spotify
   jp2a
   #System Utils
   neofetch
   #Bluetooth
   bluez       # Bluetooth daemon & utilities
   blueman     # (optional) GUI Bluetooth manager   #Automount USB
   udiskie
   # Notification Daemon
   dunst
   lxqt.lxqt-policykit  # or polkit_gnome for GUI auth dialogs
  ];

  # Cursor Enviromental Variable
    environment.variables = {
    XCURSOR_THEME = "Numix-Cursor-Light";
    XCURSOR_SIZE = "24";
  };


  # USB automount
  services.dbus.enable = true;
  services.udev.packages = [ pkgs.udiskie ];
  services.gvfs.enable = true;  # helps with automounting, optional
  services.udisks2.enable = true;
  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
