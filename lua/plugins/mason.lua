local spec = {
  {
    "williamboman/mason.nvim",
    name = "mason",
    build = ":MasonUpdate", -- This updates registry contents
    config = true,
    dependencies = { "mason-lspconfig" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    name = "mason-lspconfig",
    opts = {
      ensure_installed = { "lua_ls", "rnix" },
    },
    dependencies = { "nvim-lspconfig" },
  },
}

-- If Nix is installed, don't install mason.nvim
if vim.fn.environ().NIX_PATH == nil then
  return spec
else
  return {}
end
