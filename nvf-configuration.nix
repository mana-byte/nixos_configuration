{ pkgs, lib, config, ... }:
{
  vim = {
    package = pkgs.neovim-unwrapped;

    keymaps = [
      # Undo tree
      {
        key = "<leader>u";
        mode = ["n"];
        action = ":UndotreeToggle<CR>";
        silent = true;
        desc = "Toggle undotree";
      }

      # Splits
      {
        key = "<c-l>"; # split vertical
        mode = ["n"];
        action = ":vsplit<CR>";
        silent = true;
        desc = "Vertical split";
      }
      {
        key = "<c-h>"; # split horizontal
        mode = ["n"];
        action = ":split<CR>";
        silent = true;
        desc = "Horizontal split";
      }

      # Formatting (Conform)
      {
        key = "<leader>cf";
        mode = ["n"];
        action = ":lua require('conform').format({ async = true, lsp_fallback = true })<CR>";
        silent = true;
        desc = "Format buffer";
      }

      # File explorer (oil)
      {
        key = "-";
        mode = ["n"];
        action = ":Oil<CR>";
        silent = true;
        desc = "Open Oil";
      }

      # Noice dismiss
      {
        key = "<leader>nd";
        mode = ["n"];
        action = ":NoiceDismiss<CR>";
        silent = true;
        desc = "Dismiss notifications";
      }

      # Telescope (core pickers beyond module-provided mappings)
      {
        key = "<leader>fo";
        mode = ["n"];
        action = ":Telescope oldfiles<CR>";
        silent = true;
        desc = "Recent files";
      }
      {
        key = "<leader>fh";
        mode = ["n"];
        action = ":Telescope help_tags<CR>";
        silent = true;
        desc = "Help tags";
      }
      {
        key = "<leader>fr";
        mode = ["n"];
        action = ":Telescope resume<CR>";
        silent = true;
        desc = "Resume last Telescope";
      }
      {
        key = "<leader>fs";
        mode = ["n"];
        action = ":Telescope grep_string<CR>";
        silent = true;
        desc = "Grep string under cursor";
      }

      # LSP helpers
      {
        key = "<leader>rn";
        mode = ["n"];
        action = ":lua vim.lsp.buf.rename()<CR>";
        silent = true;
        desc = "LSP Rename";
      }
      {
        key = "<leader>ca";
        mode = ["n"];
        action = ":lua vim.lsp.buf.code_action()<CR>";
        silent = true;
        desc = "Code Action";
      }
      {
        key = "<leader>gd";
        mode = ["n"];
        action = ":lua vim.lsp.buf.definition()<CR>";
        silent = true;
        desc = "Go to Definition";
      }
      {
        key = "<leader>gr";
        mode = ["n"];
        action = ":lua vim.lsp.buf.references()<CR>";
        silent = true;
        desc = "References";
      }
      {
        key = "<leader>gi";
        mode = ["n"];
        action = ":lua vim.lsp.buf.implementation()<CR>";
        silent = true;
        desc = "Implementation";
      }
      {
        key = "<leader>gs";
        mode = ["n"];
        action = ":lua vim.lsp.buf.signature_help()<CR>";
        silent = true;
        desc = "Signature Help";
      }

      # Diagnostics navigation
      {
        key = "<leader>dn";
        mode = ["n"];
        action = ":lua vim.diagnostic.goto_next({ float = true })<CR>";
        silent = true;
        desc = "Next diagnostic";
      }
      {
        key = "<leader>dp";
        mode = ["n"];
        action = ":lua vim.diagnostic.goto_prev({ float = true })<CR>";
        silent = true;
        desc = "Prev diagnostic";
      }
      {
        key = "<leader>dl";
        mode = ["n"];
        action = ":lua vim.diagnostic.setloclist()<CR>";
        silent = true;
        desc = "Diagnostics to loclist";
      }
    ];

    git.enable = true;
    lsp.enable = true;

    globals = {
      mapleader = ","; # Retain comma as leader (consistent across keymaps)
    };

    options = {
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      cursorline = true;
      relativenumber = true;
      number = true;          # Absolute number on current line
      signcolumn = "yes";     # Avoid text shifting
      termguicolors = true;   # True color
      updatetime = 300;       # Faster CursorHold
      scrolloff = 4;          # Context lines around cursor
      splitbelow = true;      # New horizontal splits below
      splitright = true;      # New vertical splits to the right
      timeoutlen = 400;       # Faster mapped sequence timeout
      clipboard = "unnamedplus"; # System clipboard integration
      ignorecase = true;      # Case-insensitive search
      smartcase = true;       # Override ignorecase if uppercase in search
    };

    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    statusline.lualine = {
      enable = true;
      theme = "gruvbox";
    };

    telescope = {
      enable = true;
      extensions = [
        {
          name = "fzf";
          packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
          setup = {
            fzf = {
              fuzzy = true;
              case_mode = "smart_case"; # Added smarter case handling
            };
          };
        }
      ];
      # Keep core mappings; supplementary ones handled via keymaps above
      mappings = {
        findFiles = "<leader>ff";
        buffers = "<leader>fb";
        gitBranches = "<leader>gb";  # Adjusted for consistency
        gitCommits = "<leader>gc";   # Adjusted for consistency
        liveGrep = "<leader>fg";
      };
    };

    utility = {
      oil-nvim.enable = true;
      undotree.enable = true;
      motion.leap = {
        enable = true;
        mappings = {
          leapForwardTo = "s";
          leapBackwardTo = "S";
          leapFromWindow = "<leader>s";
        };
      };
      surround.enable = true;
    };

    binds.whichKey.enable = true;
    notes.todo-comments.enable = true;

    ui.noice = {
      enable = true;
      setupOpts.presets = {
        bottom_search = false;
        command_palette = true;
      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
    };

    formatter = {
      conform-nvim = {
        enable = true;
        setupOpts.formatters_by_ft = {
          lua = ["stylua"];
          python = ["black"];
          nix = ["alejandra"];
          javascript = ["biome"];
          typescript = ["biome"];
          javascriptreact = ["biome"]; # eslint removed (handled by LSP diagnostics if desired)
          typescriptreact = ["biome"]; # eslint removed
        };
      };
    };

    dashboard.alpha = {
      enable = true;
      theme = "theta";
    };

    # Autocompletion & snippets
    autocomplete = {
      blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        mappings = {
          next = "<c-n>";
          previous = "<c-p>";
        };
      };
    };

    comments.comment-nvim.enable = true;
    autopairs.nvim-autopairs.enable = true;

    assistant = {
      copilot = {
        enable = true;
        cmp.enable = true; # Ensure compatibility layer present; else switch strategy
      };
      avante-nvim.enable = true;
    };

    languages = {
      enableTreesitter = true;
      nix.enable = true;
      lua.enable = true;
      python.enable = true;
      ts.enable = true; # Provides TypeScript/TSX; adjust if module separates ts/tsx
    };
  };
}
