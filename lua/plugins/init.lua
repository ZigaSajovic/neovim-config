return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lspconfig" },
    config = function()
      require "configs.mason-lsp-config"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-cmdline" },
    },
    config = function()
      require "configs.cmp"
    end,
  },
  {
    "zapling/mason-conform.nvim",
    event = "VeryLazy",
    dependencies = { "conform.nvim" },
    config = function()
      require "configs.mason-conform"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.treesitter"
    end,
  },

  { "tpope/vim-eunuch", lazy = false },
  { "tpope/vim-surround", lazy = false },
  {
    "LukasPietzschmann/telescope-tabs",
    lazy = false,
  },
  { "junegunn/gv.vim", lazy = false },
  { "folke/trouble.nvim", lazy = false },

  {
    "hrsh7th/cmp-cmdline",
    lazy = false,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },

  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
  },

  {
    "tzachar/cmp-fuzzy-path",
    dependencies = {
      "tzachar/fuzzy.nvim",
      "hrsh7th/nvim-cmp",
    },
    lazy = false,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      messages = {
        enabled = false,
      },
      lsp = {
        signature = {
          enabled = false,
        },
      },
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "mfussenegger/nvim-dap",
  },

  {
    "farmergreg/vim-lastplace",
    lazy = false,
  },
  { "nvim-telescope/telescope-ui-select.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    config = function()
      require "configs.telescope"
    end,
  },
}
