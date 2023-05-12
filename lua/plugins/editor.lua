return {
  --- STATUSLINE ---
  {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  --- FILE EXPLORER ---
  {
    "nvim-neo-tree/neo-tree.nvim",
    name = "neo-tree",
    cmd = "Neotree",
    keys = {
      { "<Leader>f", "<cmd>Neotree position=float toggle<cr>", desc = "NeoTree" },
    },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      require "neo-tree".setup()
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- Nerd font icons
    }
  },

  --- STARTING SCREEN ---
  {
    "goolord/alpha-nvim",
    name = "alpha-nvim",
    config = function()
      require "alpha".setup(require "alpha.themes.startify".config)
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
