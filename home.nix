{
  config,
  pkgs,
  claude-desktop,
  ...
}:
{
  imports = [
    ./autocommands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
    ./todo.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "clement";
  home.homeDirectory = "/home/clement";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello
      zsh
      notion-app-enhanced
      obsidian
      bitwarden-desktop
      transmission_4-gtk
      pavucontrol
      prismlauncher
      appimage-run
      ripgrep
      gns3-gui
      gns3-server
      valgrind
      alacritty
      networkmanagerapplet
      gnumake
      git
      feh
      discord
      kubectl
      bat
      zoxide
      eza
      blueman
      spotify
      autorandr
      arandr
      btop
      tree
      dash
      man-pages
      chromium
      python3
      python3Packages.jupyter
      python3Packages.ipykernel
      steam
      kubernetes-helm-wrapped
      thunderbird
      criterion
      criterion.dev
      pkg-config
      evince
      ltrace
      ubridge
      dynamips
      electron_39
      dunst
      graphviz
      piper-tts
      autoconf
      automake
      libtool
      autoconf-archive
      pkg-config
      jellyfin-media-player
      inetutils
      vesktop
      jetbrains.idea
      lombok
      playerctl
      nwg-displays
      eww
      flameshot
      grim
      satty
      jdk21
      slurp
      cmake
      bear
      #clang-tools
      claude-desktop.packages.${pkgs.system}.claude-desktop-fhs
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    shellAliases = {
      hms = "home-manager switch";
      v = "nvim";
      c = "clear";
      #cat = "bat --theme='Catppuccin Mocha'";
      fk = "fuck";
      ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
      cd = "z";
      s = "web_search duckduckgo";
    };
    oh-my-zsh = {
      enable = true;
      extraConfig = builtins.readFile ./extraConfig.zsh;
      # Additional oh-my-zsh plugins
      plugins = [
        "web-search"
        "copyfile"
        "copybuffer"
        "fzf"
      ];
    };

    plugins = [
      # Autocompletions
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.1";
          hash = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
        };
      }
      # Completion scroll
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.35.0";
          hash = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
        };
      }
      # Highlight commands in terminal
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
    ];
    initExtra = ''
      ;
              [[ ! -f ~/.config/home-manager/.p10k.zsh ]] || source ~/.config/home-manager/.p10k.zsh
    '';
  };

  programs.direnv.enable = true;

  # Atuin
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      dialect = "us";
      style = "compact";
      inline_height = 15;
    };
  };

  # Neovim
  # Neovim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
    extraConfigLua = ''
      -- Quarto runner keymaps (Lua functions)
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<leader>rc", runner.run_cell,  { desc = "Run cell", silent = true })
      vim.keymap.set("n", "<leader>rca", runner.run_above, { desc = "Run cell and above", silent = true })
      vim.keymap.set("n", "<leader>rA", runner.run_all,   { desc = "Run all cells", silent = true })
      vim.keymap.set("n", "<leader>rl", runner.run_line,  { desc = "Run line", silent = true })
      vim.keymap.set("v", "<leader>r",  runner.run_range, { desc = "Run visual range", silent = true })
      vim.keymap.set("n", "<leader>RA", function()
        runner.run_all(true)
      end, { desc = "Run all cells of all languages", silent = true })

      -- Command to create a new empty .ipynb file
      local default_notebook = [[
      {
        "cells": [
         {
          "cell_type": "markdown",
          "metadata": {},
          "source": [""]
         }
        ],
        "metadata": {
         "kernelspec": {
          "display_name": "Python 3",
          "language": "python",
          "name": "python3"
         },
         "language_info": {
          "codemirror_mode": {
            "name": "ipython"
          },
          "file_extension": ".py",
          "mimetype": "text/x-python",
          "name": "python",
          "nbconvert_exporter": "python",
          "pygments_lexer": "ipython3"
         }
        },
        "nbformat": 4,
        "nbformat_minor": 5
      }
      ]]

      local function new_notebook(filename)
        local path = filename .. ".ipynb"
        local file = io.open(path, "w")
        if file then
          file:write(default_notebook)
          file:close()
          vim.cmd("edit " .. path)
        else
          print("Error: Could not open new notebook file for writing.")
        end
      end

      vim.api.nvim_create_user_command('NewNotebook', function(opts)
        new_notebook(opts.args)
      end, {
        nargs = 1,
        complete = 'file'
      })
    '';
  };

  # Starship command history
  programs.starship = {
    enable = true;
  };

  # Zen Browser
  programs.zen-browser = {
    enable = true;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/clement/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    PKG_CONFIG_PATH = "${config.home.profileDirectory}/lib/pkgconfig";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
