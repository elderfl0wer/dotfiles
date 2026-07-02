local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    error("lazy.nvim is not installed!")
end

vim.opt.rtp:prepend(lazypath)

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4      -- Visual width of a tab
vim.opt.shiftwidth = 4   -- Size of an indent
vim.opt.softtabstop = 4  -- Number of spaces tabs insert
vim.opt.expandtab = true -- Turn tabs into spaces

require("plugins")

vim.cmd.colorscheme("moonfly")

local map = vim.keymap.set

-- Save
map("n", "<C-s>", "<cmd>w<CR>", { silent = true })

-- Copy
map({ "n", "v" }, "<C-c>", '"+y')

-- Cut
map("v", "<C-x>", '"+d')

-- Paste
map({ "n", "v" }, "<C-v>", '"+p')

-- Select All
map("n", "<C-a>", "ggVG")

-- Find
map("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { silent = true })

-- Toggle floating terminal (VSCode-style Ctrl+`)
map("n", "<C-`>", "<cmd>ToggleTerm<CR>", { silent = true })
map("t", "<C-`>", "<cmd>ToggleTerm<CR>", { silent = true }) -- also works while inside the terminal

-- Toggle file explorer sidebar
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { silent = true })
