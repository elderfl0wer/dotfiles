-- Initialization Stuff

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    error("lazy.nvim is not installed")
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"))
require("lsp")

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

-- Transparent background: colorscheme plugins overwrite highlight groups on
-- load, so this has to run on the ColorScheme event (every time a scheme is
-- applied), not just once at startup.
local function set_transparent_highlights()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_transparent_highlights,
})

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.g.c_syntax_for_h = 1

-- Colorscheme itself (options + vim.cmd.colorscheme) now lives in
-- plugins.lua next to the gruvbox-material plugin spec, so it's set exactly
-- once, at plugin load time. Swap schemes there, not here.

-- Keymaps
local map = vim.keymap.set
-- NORMAL MODE --
local builtin = require("telescope.builtin")

map("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { silent = true })
map("n", "<C-p>", builtin.find_files, { silent = true })

map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", {
    silent = true,
    desc = "Toggle file explorer",
})

map("n", "<C-l>", "<cmd>ToggleTerm<CR>", { silent = true })

-- Save, VSCode-style, from any mode
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { silent = true, desc = "Save file" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Buffer navigation, like browser/editor tabs
map("n", "<C-Tab>", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<CR>", { silent = true, desc = "Previous buffer" })
map("n", "<C-w>", "<cmd>bdelete<CR>", { silent = true, desc = "Close buffer" })

-- Move line(s) up/down, VSCode Alt+Up/Down but on Ctrl
map("n", "<C-j>", "<cmd>m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<C-k>", "<cmd>m .-2<CR>==", { silent = true, desc = "Move line up" })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Undo/redo in insert mode without leaving it
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })

-- VISUAL MODE --
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })

