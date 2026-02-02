{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixvimInjections = true;
      nixGrammars = true; # ← IMPORTANT pour Nix
      folding = true;

      settings = {
        indent.enable = true;
        highlight.enable = true;
        auto_install = false; # ← CHANGÉ : false pour Nix !
      };

      # Déclarez explicitement vos langages
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cpp
        css
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        python
        regex
        toml
        vim
        vimdoc
        yaml
        asm
        # Ajoutez tous les langages dont vous avez besoin
      ];
    };

    treesitter-refactor = {
      enable = true;
      settings = {
        highlight_definitions = {
          enable = true;
          clear_on_cursor_move = false;
        };
      };
    };

    hmts.enable = true;
  };
}
