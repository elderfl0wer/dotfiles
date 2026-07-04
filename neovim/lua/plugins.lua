require("lazy").setup({

    {
        "bluz71/vim-moonfly-colors"
    },

    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "c",
                    "cpp",
                    "lua",
                    "vim",
                },

                highlight = {
                    enable = true,
                },

                indent = {
                    enable = true,
                },
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },

    {
        "andweeb/presence.nvim",
        config = function()
            require("presence").setup({
                auto_update = true,
                neovim_image_text = "Neovim",
                main_image = "neovim",
                show_time = true,
            })
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                direction = "float",
                float_opts = {
                    border = "curved",
                },
                -- Force PowerShell instead of the default cmd.exe on Windows
                shell = "powershell.exe -NoLogo",
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local api = require("nvim-tree.api")

            require("nvim-tree").setup({
                actions = {
                    remove_file = {
                        close_window = true,
                    },
                },
                filesystem_watchers = {
                    -- Disabled entirely. It was meant to auto-refresh the
                    -- tree when files change outside Neovim, but on large
                    -- folders it kept flooding and disabling itself with
                    -- warning spam. Press "R" in NvimTree to refresh
                    -- manually if something changes outside Neovim.
                    enable = false,
                },
                -- Just in case anything still tries to shell out to a
                -- "trash" binary, point it at something harmless so it
                -- never blocks (the keymaps below bypass it anyway).
                trash = {
                    cmd = "echo",
                    require_confirm = true,
                },
                on_attach = function(bufnr)
                    -- Load the default keymaps first
                    api.config.mappings.default_on_attach(bufnr)

                    local opts = function(desc)
                        return { desc = "NvimTree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end

                    -- Override every delete-related key (lowercase AND
                    -- uppercase, in case trash is bound to "D" instead of
                    -- "d" in your nvim-tree version) so files are always
                    -- permanently removed instead of routed through the
                    -- missing "trash" binary.
                    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
                    vim.keymap.set("n", "D", api.fs.remove, opts("Delete"))
                end,
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim"
    },

    -------------------------------------------------------------------------
    -- Autocomplete
    -------------------------------------------------------------------------

    {
        "L3MON4D3/LuaSnip",
    },

    {
        "saadparwaiz1/cmp_luasnip",
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },

        config = function()
            local cmp = require("cmp")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),

                sources = {
                    { name = "luasnip" },
                },
            })
        end,
    },

})
