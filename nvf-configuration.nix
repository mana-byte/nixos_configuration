{
  pkgs,
  lib,
  config,
  ...
}: {
  vim.package = pkgs.neovim-unwrapped;

  vim.keymaps = [
    {
      key = "<leader>u";
      mode = ["n"];
      action = ":UndotreeToggle<CR>";
      silent = true;
      desc = "Toggle undotree";
    }
    {
      key = "<c-l>";
      mode = ["n"];
      action = ":vsplit<CR>";
      silent = true;
      desc = "VSPLIT";
    }
    {
      key = "<c-h>";
      mode = ["n"];
      action = ":split<CR>";
      silent = true;
      desc = "SPLIT";
    }
    {
      key = "<leader>nd";
      mode = ["n"];
      action = ":NoiceDismiss<CR>";
      silent = true;
      desc = "remove all notifications";
    }
    {
      key = "<space>ff";
      mode = ["n"];
      action = ":lua require('conform').format({ async = true, lsp_fallback = true })<CR>";
      silent = true;
      desc = "format buffer";
    }
    {
      key = "-";
      mode = ["n"];
      action = ":Oil<CR>";
      silent = true;
      desc = "format buffer";
    }

  ];

  vim = {

    git.enable = true;
    lsp.enable = true;

    globals = {
      mapleader = ",";
    };
    options = {
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      cursorline = true;
      relativenumber = true;
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
      mappings = {
        findFiles = "<leader>ff";
        gitBranches = "<leader>fb";
        gitCommits = "<leader>fv";
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

    ui.noice =  {
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
          python = [ "black" ];
          nix = [ "alejandra" ];
          javascript = [ "biome" ];
          typescript = [ "biome" ];
          javascriptreact = [ "biome" "eslint" ];
          typescriptreact = [ "biome" "eslint" ];
        };
      };
    };
    dashboard.alpha = {
      enable = true;
      theme = "theta";
    };


    #NOTE: Autocompletion and LSPs
    autocomplete = {
      blink-cmp.enable = true;
    };
    comments.comment-nvim.enable = true;
    snippets.luasnip.enable = true;
    autopairs.nvim-autopairs.enable = true;
    assistant = {
      copilot = {
        enable = true;
        cmp.enable = true;
      };
      codecompanion-nvim.enable = true;
    };

    languages = {
      enableTreesitter = true;

      nix.enable = true;
      lua.enable = true;
      python.enable = true;
      ts.enable = true;
    };
  };

  # NOTE: Plugins that are not in nvf repo
}
