return {
  --- LSP ---
  {
    "neovim/nvim-lspconfig",
    name = "nvim-lspconfig",
    event = "BufEnter",
    config = function()
      local lspconfig = require "lspconfig"
      -- Improved completion capabilities
      local capabilities = require "cmp_nvim_lsp".default_capabilities()

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            -- The version of Lua I'm using (Neovim uses LuaJIT)
            runtime = { version = "LuaJIT" },
            diagnostics = {
              -- Tell the server that this thing exists
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Don't send any telemetry
            telemetry = { enable = false },
          },
        },
        capabilities = capabilities,
      }

      lspconfig.rnix.setup {
        settings = {},
      }
    end,
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
  },

  --- COMPLETION ---
  {
    "hrsh7th/nvim-cmp",
    name = "nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require "cmp"

      -- Custom mappings
      local custom_mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-e>"] = cmp.mapping.abort(),
      }

      cmp.setup {
        snippet = {
          -- Specify a snippet engine
      	  expand = function(args)
      	    vim.fn["vsnip#anonymous"](args.body)
      	  end,
	      },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
	      -- Custom menu direction
	      view = {
	        entries = { name = "custom", selection_order = "near_cursor" },
	      },
        mapping = custom_mapping,
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "vsnip" },
          }, {
            { name = "buffer" },
        }),
	      -- Nerd font icons (lspkind.nvim)
	      formatting = {
	        format = require "lspkind".cmp_format {
	          mode = "symbol", -- Show symbol annotations only
	          maxwidth = 50,
	          -- When the popup menu exceeds `maxwidth`, show an ellipsis
	          ellipsis_char = "...",

            -- The function below will be called before any actual modifications from lspkind
	          before = function(_, vim_item)
	            return vim_item
	          end,
	        },
	      },
      }

      -- Use buffer source for searching
      cmp.setup.cmdline({ "/", "?" }, {
	      mapping = custom_mapping,
	      sources = {
	        { name = "buffer" },
	      },
      })

      -- Use cmdline & path source for commands
      cmp.setup.cmdline(":", {
	      mapping = custom_mapping,
	      sources = cmp.config.sources({
	          { name = "path" },
	        }, {
	          { name = "cmdline" },
	      }),
      })
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/vim-vsnip", -- For snippets
      "hrsh7th/cmp-vsnip",
      "onsails/lspkind.nvim", -- For completion menu icons
    },
  },

  --- TREESITTER ---
  {
    "nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    event = "BufEnter",
    build = ":TSUpdate",
    config = function()
      require "nvim-treesitter.configs".setup {
        -- A list of parsers that should always be installed, or "all"
        ensure_installed = { "lua", "vim", "vimdoc", "query", "nix", "rust", "python" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = {},

        highlight = {
          enable = true,

          -- Disable slow treesitter highlight for large files
          disable = function(_, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                  return true
              end
          end,

          -- When true, runs treesitter highlighting together with builtin `:h syntax`
          -- Only set to `true` if `syntax` has to be enabled (for indentation for example) 
          -- May slow down the editor and show duplicate highlights
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },

  --- AUTOPAIRS ---
  {
    "windwp/nvim-autopairs",
    name = "nvim-autopairs",
    event = "BufEnter",
    config = function()
      require "nvim-autopairs".setup {
        -- Use treesitter to check for pairs
        check_ts = true,
        ts_config = {},
        -- Will not add a close pair if one already exists
        enable_check_bracket_line = true,
      }

      require "cmp".event:on(
        "confirm_done",
        require "nvim-autopairs.completion.cmp".on_confirm_done()
      )
    end,
    dependencies = { "nvim-cmp", "nvim-treesitter" },
  },

  --- INDENT-BLANKLINE ---
  {
    "lukas-reineke/indent-blankline.nvim",
    name = "indent-blankline",
    event = "BufEnter",
    opts = {
      -- Context is off by default, this turns it on
      show_current_context = true,
      -- Only show context lines
      char = "",
      context_char = "│",

      -- Maximum indent level increase
      max_indent_increase = 1,
      -- Show indent only on the same line as context
      show_trailing_blankline_indent = false,
    },
  },
}
