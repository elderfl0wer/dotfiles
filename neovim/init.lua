-- Initialization Stuff

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    error("lazy.nvim is not installed")
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"))

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Base
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true      
vim.opt.shiftwidth = 4         
vim.opt.tabstop = 4            
vim.opt.softtabstop = 4

vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.g.c_syntax_for_h = 1

vim.cmd.colorscheme("moonfly")

-- Keymaps
local map = vim.keymap.set
-- NORMAL MODE
local builtin = require("telescope.builtin")

map("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { silent = true })
map("n", "<C-p>", builtin.find_files, { silent = true })

map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", {
    silent = true,
    desc = "Toggle file explorer",
})

map("n", "<C-l>", "<cmd>ToggleTerm<CR>", { silent = true })
