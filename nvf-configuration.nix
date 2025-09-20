{
  pkgs,
  lib,
  config,
  ...
}: {
  vim.package = pkgs.neovim-unwrapped;
  vim = {
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
    git.enable = true;

    ui = {
      noice.enable = true;
    };
    visuals = {
      nvim-web-devicons.enable = true;
    };
    formatter = {
      conform-nvim.enable = true;
    };

    # Autocompletion
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
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      lua.enable = true;
      python.enable = true;
      ts.enable = true;
    };
  };
}
