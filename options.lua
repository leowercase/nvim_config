local opt = vim.opt

-- Use the system clipboard
opt.clipboard = "unnamedplus"

-- Hybrid line numbers
opt.number = true
opt.relativenumber = true
-- The width of the line number column
opt.numberwidth = 10

-- Use    four    spaces instead of tabs by default
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 4
opt.tabstop = 4
-- Automatical indentation based on context
opt.smartindent = true

-- Automatically change current directory when editing files
-- Some plugins might not work correctly with this setting
opt.autochdir = true
