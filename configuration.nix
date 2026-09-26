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
    # Disarankan dokumentasi AeroSpace: tanpa ini Mission Control menampilkan
    # jendela yang disembunyikan AeroSpace sebagai kotak mungil di pojok.
    dock.expose-group-apps = true;
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
    # Selain yang disebut di sini, --no-upgrade bawaan nix-darwin tetap berlaku.
    # herdr ikut dinaikkan tiap rebuild (setelan terbaru Kun memakai Herdr >= 0.9,
    # mis. panel "machines"); pembaruan herdr kini lewat rebuild ini, sehingga
    # pemeriksaan versi bawaan herdr dimatikan di home/.config/herdr/config.toml.
    onActivation.extraFlags = [ "--force" "--upgrade-formulae=herdr" ];
    # Tanpa tap ini, zap melepasnya dan supabase CLI ikut terhapus.
    taps = [
      "supabase/tap"
      # Bar atas, bingkai jendela, dan tiling gaya Kun Chen (data/kun-visual).
      "FelixKratz/formulae"   # sketchybar, borders
      "nikitabobko/tap"       # aerospace
      "kunchenguid/tap"       # baby-menu, widget kuota AI di menu bar buatan Kun
    ];
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
      "gnhf"                # tool Kun Chen; ada di homebrew-core, sebelumnya via npm
      "opencode"            # harness keempat; brew 1.18.5, terdekat dgn npm
      # Dipasang kapten setelah rebuild 2026-07-28; kapten memutuskan semuanya
      # dipertahankan, jadi dideklarasikan agar zap tidak membuangnya.
      "amass"
      "cargo-deny"
      "expat"
      "findomain"
      "hcloud"
      "librsvg"
      "mysql"
      "nak"
      "nginx"
      "opentofu"
      "potrace"
      "tmux"
      "wireshark"
      # Tampilan desktop Kun Chen: bar atas + bingkai jendela aktif. Keduanya
      # dijalankan oleh after-startup-command AeroSpace, bukan brew services.
      "FelixKratz/formulae/sketchybar"
      "FelixKratz/formulae/borders"
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
      "opensuperwhisper"    # input suara lokal; sebelumnya .dmg manual
      "kunchenguid/tap/baby-menu"  # widget kuota Claude/Codex di menu bar, seperti video Kun
      "nikitabobko/tap/aerospace"  # tiling + workspace bernomor gaya Kun Chen
    ];
  };
}
