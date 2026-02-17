# CLAUDE.md — AI Assistant Guide for home-manager

## Project Overview

This is a **Nix Home Manager configuration** repository that declaratively manages the Linux home environment for user `clement`. It uses [NixVim](https://github.com/nix-community/nixvim) (nixos-25.11 branch) to configure Neovim as a full-featured IDE, alongside Zsh shell setup, system packages, and developer tools.

**Not a traditional software project** — there is no build system, test suite, or CI/CD pipeline. The entire configuration is validated and applied via `home-manager switch`.

## Repository Structure

```
home-manager/
├── home.nix              # Main entry point — packages, shell, programs, imports
├── options.nix           # Neovim editor options (line numbers, tabs, folding, etc.)
├── keymappings.nix       # All Neovim keybindings (leader=Space)
├── autocommands.nix      # Neovim autocommands
├── completion.nix        # Completion engine configuration
├── todo.nix              # TODO/FIXME highlight configuration
├── extraConfig.zsh       # Extra Zsh shell config (zoxide, direnv, starship, fzf)
└── plugins/              # Neovim plugin configurations (one file per plugin)
    ├── default.nix       # Plugin imports + colorscheme (Catppuccin macchiato)
    ├── lsp.nix           # Language Server Protocol servers
    ├── dap.nix           # Debug Adapter Protocol configuration
    ├── telescope.nix     # Fuzzy finder
    ├── tree-sitter.nix   # Syntax parsing
    ├── lualine.nix       # Status line
    ├── oil.nix           # File explorer
    ├── jupyter.nix       # Jupyter/Molten/Quarto notebook support
    ├── lazygit.nix       # Git UI integration
    ├── harpoon.nix       # Quick file navigation
    ├── blink-cmp.nix     # Completion plugin
    ├── lint.nix          # Linting configuration
    └── ...               # (25+ plugin files total)
```

## Key Technologies

| Component | Technology |
|---|---|
| Config language | Nix |
| Package manager | Nix / Home Manager (v25.05) |
| NixVim branch | nixos-25.11 |
| Editor | Neovim (via NixVim) |
| Shell | Zsh + Oh-My-Zsh + Starship prompt |
| Colorscheme | Catppuccin (macchiato) |
| Terminal | Alacritty |

## How to Apply Changes

```bash
home-manager switch
```

This is the **only** deployment command. It evaluates all `.nix` files, builds the configuration, and activates it (symlinks, environment variables, etc.). There is no separate build or test step — Nix evaluation itself validates the configuration.

The shell alias `hms` is equivalent to `home-manager switch`.

## Nix Code Conventions

### File Organization
- **One plugin per file** under `plugins/` — each file configures a single Neovim plugin
- **`plugins/default.nix`** imports all plugin files and sets the colorscheme + shared plugins (gitsigns, autopairs, surround, trim, etc.)
- **`home.nix`** is the root — it imports all top-level modules and configures non-Neovim programs (zsh, direnv, atuin, starship)

### Nix Style
- Standard 2-space indentation for Nix code
- Configuration paths use `programs.nixvim.*` for all Neovim settings
- Plugin settings use the NixVim module system (attribute sets, not raw Lua when possible)
- Complex logic that cannot be expressed in Nix uses inline Lua via `extraConfigLua` or `__raw`
- Disabled alternatives are kept with `enable = false` (e.g., alternative colorschemes) rather than deleted

### Keymapping Pattern
All keymaps follow this structure in `keymappings.nix`:
```nix
{
  action = ":SomeCommand<CR>";
  key = "<leader>xx";
  options = {
    silent = true;
    noremap = true;
    desc = "Description of the action";
  };
}
```
- **Leader key**: Space (both `mapleader` and `maplocalleader`)
- Every keymap should include a `desc` field

### Adding a New Plugin
1. Create `plugins/<plugin-name>.nix`
2. Add the import to `plugins/default.nix`
3. Configure under `programs.nixvim.plugins.<plugin-name>`

### Adding a New Package
Add it to the `home.packages` list in `home.nix` using `with pkgs;` syntax.

## LSP Servers Configured

| Server | Language |
|---|---|
| `gopls` | Go |
| `clangd` | C/C++ |
| `golangci_lint_ls` | Go (linting) |
| `lua_ls` | Lua |
| `nil_ls` | Nix |
| `pyright` | Python (type checking) |
| `pylsp` | Python (language server) |
| `tflint` | Terraform |
| `jdtls` | Java |

## Important Keybindings Reference

| Key | Action |
|---|---|
| `<leader>o` | Oil file explorer |
| `<leader>sf` | Telescope find files |
| `<leader>sg` | Telescope live grep |
| `<leader>sb` | Telescope buffers |
| `<leader>lg` | LazyGit |
| `<leader>gd` | Go to definition |
| `<leader>gr` | Go to references |
| `<leader>t` | Trouble diagnostics |
| `<leader>b` | Toggle breakpoint |
| `<leader>dc` | DAP continue |
| `<leader>rc` | Run Jupyter cell |
| `<Tab>/<S-Tab>` | Next/Previous buffer |
| `<C-h/j/k/l>` | Window navigation |

## Shell Environment

**Zsh aliases** (defined in `home.nix`):
- `hms` = `home-manager switch`
- `v` = `nvim`
- `c` = `clear`
- `ls` = `eza` (with color, git info, icons)
- `cd` = `z` (zoxide)
- `s` = `web_search duckduckgo`

**Integrations** (from `extraConfig.zsh`): zoxide, direnv, starship, fzf with preview.

**Oh-My-Zsh plugins**: web-search, copyfile, copybuffer, fzf.

**Zsh plugins**: zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting.

## Things to Watch Out For

- **No `.gitignore`** — be careful not to commit sensitive files
- **No tests or CI** — the only validation is `home-manager switch` succeeding
- **NixVim fetched via `builtins.fetchGit`** (not flakes) — pinned to `nixos-25.11` branch
- **Typo in keymappings.nix** — line 274 has `<leadr>dc` instead of `<leader>dc` for DapContinue
- **Duplicate `<leader>sc`** binding — mapped to both `Telescope command_history` and `Telescope commands`
- **Some comments are in French** (e.g., in tree-sitter.nix)
- **`packer.nix`** references a local dev path `~/Code/Sandbox/rduck.nvim` — this is a user-specific local plugin
- **All Nerd Fonts** are installed via a filter on `pkgs.nerd-fonts` at the end of `home.packages`
