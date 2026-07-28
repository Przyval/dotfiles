{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    # Homebrew sudah terpasang di /opt/homebrew sebelum Nix ada; tanpa ini
    # nix-homebrew menolak mengambil alih prefix yang sudah terisi.
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    # Tanpa tap ini, zap melepasnya dan supabase CLI ikut terhapus.
    taps = [ "supabase/tap" ];
    brews = [
      "apktool"
      "autossh"
      "binutils"
      "cloudflared"
      "cmake"
      "cocoapods"
      "composer"
      "coreutils"
      "dex2jar"
      "dnsx"
      "dotnet"
      "duckdb"
      "espeak-ng"
      "exiftool"
      "flyctl"
      "fswatch"
      "gh"
      "ghidra"
      "git"
      "gitleaks"
      "gobuster"
      "hashcat"
      "herdr"
      "httpx"
      "ipatool"
      "jadx"
      "kotlin"
      "libomp"
      "maven"
      "megacmd"
      "mysql-client"
      "netcat"
      "ninja"
      "nmap"
      "node"
      "nuclei"
      "nvm"
      "p7zip"
      "php@8.3"
      "pipx"
      "poppler"
      "postgresql@16"
      "py-spy"
      "pyenv"
      "python@3.12"
      "radare2"
      "rclone"
      "redis"
      "ripgrep"
      "rizin"
      "scrcpy"
      "semgrep"
      "sshpass"
      "subfinder"
      "unar"
      "wget"
      "yara"
      "yq"
      "yt-dlp"
      "sdl3"              # dep sdl2-compat; tanpa disebut, `brew bundle`
                          # crash "key not found: sdl3" saat topo sort
      "sdl2-compat"       # dep opsional ffmpeg/scrcpy; zap membuangnya kalau tak disebut
      "supabase/tap/supabase"  # dari tap; tidak pernah muncul di `brew leaves`
      "aribb24"
      "cjson"
      "flac"
      "frei0r"
      "fribidi"
      "leptonica"
      "libarchive"
      "libass"
      "libb2"
      "libbluray"
      "libmicrohttpd"
      "libogg"
      "librist"
      "libsamplerate"
      "libsndfile"
      "libsoxr"
      "libssh"
      "libudfread"
      "libunibreak"
      "libvidstab"
      "libvorbis"
      "mbedtls@3"
      "opencore-amr"
      "pango"
      "rav1e"
      "rubberband"
      "snappy"
      "speex"
      "srt"
      "tesseract"
      "theora"
      "xvid"
      "zeromq"
      "zimg"
    ];
    casks = [
      "android-commandlinetools"
      "android-platform-tools"
      "docker-desktop"
      "flutter"
      # "hermes"  -- cask DIHAPUS dari homebrew-cask upstream (API 404);
      #              entri usangnya membuat `brew bundle` gagal deserialisasi.
      #              Hermes.app dicadangkan di ~/pre-nix-backup/
      "localsend"
      "megacmd-app"
      "ngrok"
      "temurin@17"
      "vlc"
      "wezterm"
    ];
  };
}
