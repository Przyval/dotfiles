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
  home.sessionVariables.EDITOR = "nvim";

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

  # Config shell pribadi. Berkasnya di-gitignore (memuat kredensial dan nomor
  # telepon; repo ini fork publik), jadi ia hidup hanya di mesin ini.
  home.file.".config/zsh/personal.zsh".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/zsh/personal.zsh";

  # DINONAKTIFKAN -- keputusan ditunda.
  # Kedua berkas ini dipakai BERSAMA oleh ekstensi Claude Code di VS Code dan
  # claude CLI di terminal. Menautkannya ke berkas Kun Chen akan mengganti
  # instruksi pribadi (trigger /graphify, email) dan settings yang sedang
  # dipakai 6 sesi VS Code yang berjalan. Aktifkan hanya setelah isinya
  # dibandingkan berdampingan dan digabungkan.
  #
  # home.file.".claude/settings.json".source =
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  # home.file.".claude/CLAUDE.md".source =
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  # Codex dan opencode tidak dipakai Claude Code, jadi aman diaktifkan.
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
