# Neovim (NVF) Configuration — Nix Flake

**This readme is ai generated**
This repository contains a NixOS configuration and a reproducible, declarative Neovim setup powered by NVF (notashelf/nvf). The Neovim configuration is defined in `nvf-configuration.nix` and exported as a flake package so you can build or run it anywhere with Nix.

- Flake entry: `flake.nix`
- Neovim module: `nvf-configuration.nix`
- Target platform: `x86_64-linux`

## Quick Start

Prerequisites:
- Nix with flakes enabled (set `nix.settings.experimental-features = ["nix-command" "flakes"];`).
- Linux x86_64.

Build the configured Neovim and run it locally (without installing):
- Build: `nix build .#default`
- Run: `./result/bin/nvim`

Or run directly with flake:
- `nix run .#default`

Install the package into your user profile:
- `nix profile install .#default`

Using the NixOS configuration (optional):
- `sudo nixos-rebuild switch --flake .#nixos`

## Highlights

- Solid UI/UX defaults
  - Theme: Gruvbox (dark)
  - Statusline: Lualine (gruvbox theme)
  - Icons: nvim-web-devicons
  - Dashboard: alpha-nvim (theta)
  - Messaging/commandline UI: Noice (+ nvim-notify)
  - Color highlighting: nvim-colorizer
  - File explorer: oil.nvim
  - Window ergonomics: windows-nvim, equalize/maximize helpers
  - Inline diagnostics: tiny-inline-diagnostic (disables noisy virtual text)

- Navigation & discovery
  - Telescope with fzf-native (smart-case fuzzy search)
  - Leap motion for fast navigation
  - Which-key hints for discoverable keymaps
  - Undotree for history exploration

- LSP, diagnostics, formatting
  - LSP enabled (built-in Neovim LSP)
  - Diagnostics surfacing via Trouble + inline diagnostics
  - Formatting via conform.nvim with opinionated per-language defaults

- Completion and editing
  - nvim-cmp with bordered UI
  - Autopairs and Comment.nvim enabled by default
  - Surround actions for fast text editing

- AI assistants
  - GitHub Copilot (completion integration enabled)
  - avante-nvim enabled

- Languages
  - Treesitter enabled
  - Language toggles: Nix, Lua, Python, TypeScript (incl. TSX)
  - Markdown rendering enhancements

## Editor Options

- Indentation: 2 spaces (`tabstop`, `shiftwidth`, `softtabstop` = 2, `expandtab`)
- Cursor + numbers: `cursorline = true`, `relativenumber = true`, `number = true`
- UI polish: `signcolumn = "yes"`, `termguicolors = true`, `updatetime = 300`, `scrolloff = 3`
- Split behavior: `splitbelow = true`, `splitright = true`
- Input/clipboard: `timeoutlen = 400`, `clipboard = "unnamedplus"`
- Search: `ignorecase = true`, `smartcase = true`
- Leader key: `,` (comma)

## Keymaps

Leader is set to `,` (comma). The configuration also intentionally uses a literal `<space>` in one mapping for formatting.

General:
- Toggle Undotree: `<leader>u`
- Oil file explorer: `-`
- Dismiss Noice notifications: `<leader>nd`

Windowing:
- Vertical split: `<C-l>`
- Horizontal split: `<C-h>`
- Equalize windows: `<leader>we`
- Maximize current window: `<leader>wm`

Formatting:
- Format buffer (Conform): `<space>ff` (note: literal space, not `<leader>`)

Telescope (module mappings and extra helpers):
- Find files: `<leader>ff`
- Buffers: `<leader>fb`
- Live grep: `<leader>fg`
- Git branches: `<leader>gb`
- Git commits: `<leader>gc`
- Recent files: `<leader>fo`
- Help tags: `<leader>fh`
- Resume last picker: `<leader>fr`
- Grep string under cursor: `<leader>fs`

LSP:
- Rename: `<leader>rn`
- Code action: `<leader>ca`
- Go to definition: `<leader>gd`
- References: `<leader>gr`
- Implementation: `<leader>gi`
- Signature help: `<leader>gs`

Diagnostics:
- Open Trouble: `<C-t>`
- Next diagnostic: `<leader>dn`
- Previous diagnostic: `<leader>dp`
- Send diagnostics to location list: `<leader>dl`

## Formatters (conform.nvim)

Configured by filetype:
- Lua: `stylua`
- Python: `black`
- Nix: `alejandra`
- JavaScript/TypeScript/React (js, ts, jsx, tsx): `biome` (single source of formatting)

Notes:
- ESLint is intentionally not used as a formatter here to avoid conflicts and slowdowns. Use ESLint via LSP for diagnostics if desired.

## Telescope

- fzf-native extension enabled for fast fuzzy search
- `case_mode = "smart_case"` for intuitive matching
- Common pickers are bound under `<leader>f?` and `<leader>g?` mnemonics

## Plugins Overview

Core/UX:
- `noice.nvim`, `nvim-notify`, `alpha-nvim`, `lualine.nvim`, `nvim-web-devicons`, `nvim-colorizer.lua`

Navigation/Discovery:
- `telescope.nvim` + `telescope-fzf-native.nvim`, `oil.nvim`, `undotree`

Motion/Editing:
- `leap.nvim`, `nvim-surround`, `Comment.nvim`, `nvim-autopairs`, `which-key.nvim`

Diagnostics/Lists:
- `trouble.nvim`, `todo-comments.nvim`, `tiny-inline-diagnostic.nvim`

Windows/UI Polish:
- `windows.nvim`, `lensline.nvim`, `smear-cursor.nvim`

Completion/AI:
- `nvim-cmp` (+ borders), GitHub Copilot, `avante-nvim`

## Flake Layout

```nix
# flake.nix (excerpt)
packages."x86_64-linux".default =
  (nvf.lib.neovimConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    modules = [ ./nvf-configuration.nix ];
  }).neovim;

nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
  modules = [
    { nix.settings.experimental-features = ["nix-command" "flakes"]; }
    ./configuration.nix
  ];
};
```

- `packages.x86_64-linux.default` exposes the configured Neovim as a derivation
- `nixosConfigurations.nixos` references the system configuration (optional to use)

## Customisation

Most configuration is declarative under `vim = { ... };` in `nvf-configuration.nix`:
- Change theme: `vim.theme`
- Toggle plugins: e.g. `vim.ui.noice.enable = true;`
- Add keymaps: `vim.keymaps = [ { key = "..."; mode = ["n"]; action = "..."; } ];`
- Adjust options: `vim.options` (e.g. `scrolloff`, `splitright`, etc.)
- LSP: `vim.lsp.enable = true;` and language toggles in `vim.languages`
- Formatters: `vim.formatter.conform-nvim.setupOpts.formatters_by_ft`
- Extra plugins: add to `vim.extraPlugins` with `package` plus minimal `setup`

## Troubleshooting

- Language servers: Ensure your language servers are available in PATH (via `nix profile install`, devShell, or system configuration). NVF wires Neovim LSP; it does not install servers automatically.
- Copilot/Avante: Authenticate and configure credentials through environment variables or your preferred secrets manager. Avoid storing secrets in the Nix store.
- Treesitter parsers: Enable additional languages as needed under `vim.languages`.
- Keymaps: Remember that `<space>ff` is a literal space + `ff` for formatting; search is under `<leader>ff`.

## Updating

- Update inputs and rebuild: `nix flake update && nix build .#default`
- Run the new build: `./result/bin/nvim`

---

This configuration aims to be fast, discoverable, and comfortable for daily editing, with reproducible results via Nix flakes and NVF.

