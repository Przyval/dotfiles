{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";

    # Toggle perilaku Claude Code, disamakan dengan dotfiles Kun (video
    # 2026-09-13, 35:05). Sengaja env shell, bukan ~/.claude/settings.json,
    # supaya Claude yang menulis ulang settings.json tidak bisa membatalkannya.
    CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING = "1";
    CLAUDE_CODE_DISABLE_AUTO_MEMORY = "1";
    CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
    CLAUDE_CODE_AUTO_COMPACT_WINDOW = "500000";  # compact otomatis di 500k token
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept

      # Sebelumnya di ~/.zprofile.
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Sebelumnya di ~/.zshenv.
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

      # Config pribadi: nvm, uv, PATH mysql-client/libpq/Android/maestro, bun,
      # dan fungsi database GoodFellas. Disimpan sebagai berkas terpisah, BUKAN
      # inline di sini, karena dua alasan:
      #   1. Isinya memuat kredensial dan nomor telepon; repo ini fork publik,
      #      jadi berkasnya di-gitignore dan tidak pernah ter-commit.
      #   2. Skrip aslinya penuh ''${...} yang akan ditafsirkan Nix sebagai
      #      interpolasi kalau ditempel ke dalam string ini.
      # Ia menginisialisasi nvm, tempat `claude` CLI terminal terpasang.
      [ -f "$HOME/.config/zsh/personal.zsh" ] && . "$HOME/.config/zsh/personal.zsh"

      # brew shellenv di atas dan personal.zsh sama-sama MEMPREPEND PATH,
      # menggeser profil Nix ke belakang /opt/homebrew/bin. Akibatnya `rg`
      # teresolusi ke Homebrew, bukan ke paket yang dideklarasikan home.packages.
      # Repo hulu tidak mengalami ini karena initContent-nya tidak memanggil
      # brew shellenv sama sekali -- nix-homebrew sudah menaruh `brew` di
      # /run/current-system/sw/bin. Mesin ini memerlukannya karena 228 paket
      # Homebrew-nya hidup di /opt/homebrew/bin.
      #
      # SENGAJA hanya profil per-user, bukan /run/current-system/sw/bin: profil
      # sistem memuat brew, bash, dan zsh, dan memprioritaskannya akan mengubah
      # biner `brew` yang dipakai interaktif -- jauh melampaui kebutuhan.
      export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      # `cc` milik Kun Chen adalah `claude --dangerously-skip-permissions`, yang
      # mematikan SEMUA konfirmasi izin. Dinonaktifkan sampai diputuskan sadar.
      # cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";

  # Tiling, bar atas, dan bingkai jendela gaya Kun Chen (data/kun-visual).
  home.file.".config/aerospace".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/aerospace";
  home.file.".config/sketchybar".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/sketchybar";
  home.file.".config/borders".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/borders";

  # Config shell pribadi. Berkasnya di-gitignore (memuat kredensial dan nomor
  # telepon; repo ini fork publik), jadi ia hidup hanya di mesin ini.
  home.file.".config/zsh/personal.zsh".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/zsh/personal.zsh";

  # Keep Pi's credential and runtime state local by linking only authored files and directories.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  # Satu memory file untuk semua agen -- pola Kun Chen. Isi CLAUDE.md lama
  # (trigger /graphify) sudah digabungkan ke home/AGENTS.md, jadi tidak ada
  # yang hilang. Berkas lama tetap diselamatkan sebagai *.hm-bak.
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  # Dirujuk dari AGENTS.md, bukan dimuat otomatis: agent hanya membacanya saat
  # relevan, sehingga system prompt tetap ramping.
  home.file."OPINIONS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/OPINIONS.md";
  home.file."VOICE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/VOICE.md";

  # settings.json BUKAN berkas lintas-agen -- ia khusus Claude, dan Kun Chen
  # men-symlink-nya semata agar terversi di dotfiles. Isinya di repo ini adalah
  # GABUNGAN: permissions, plugin mattpocock, dan effortLevel milik mesin ini,
  # ditambah statusLine milik Kun Chen. Menyalin berkasnya mentah-mentah akan
  # mencabut plugin dan mengembalikan mode izin.
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
