return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "rust", "c", "cpp", "python", "lua", "toml", "java", "kotlin" },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        }
    },

    {
        "lewis6991/gitsigns.nvim",
    },

    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({})
        end,
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^5',
        lazy = false,
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(client, bufnr)
                    end,
                    settings = {
                        ['rust-analyzer'] = {
                            cargo = { allFeatures = true },
                            checkOnSave = { command = 'clippy' },
                            inlayHints = { enable = true },
                        },
                    },
                },
            }
        end
    },

    {
        'saecki/crates.nvim',
        tag = 'stable',
        event = { "BufRead Cargo.toml" },
        config = function()
            require('crates').setup({
                completion = {
                    cmp = { enabled = true },
                },
            })
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            direction = "float",
            float_opts = {
                border = "rounded",
                width = 120,
                height = 30,
            },
            shell = "powershell",
        },
    },

    {
        "neovim/nvim-lspconfig",
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    {
        "andweeb/presence.nvim",
        event = "VeryLazy",
        opts = {
            auto_update = true,
            enable_line_number = false,
            buttons = false,
            editing_text = "Editing %s",
            reading_text = "Reading %s",
            workspace_text = "Working on %s",
            file_explorer_text = "Browsing files",
        },
    },

    {
        "bluz71/vim-moonfly-colors",
        config = function()
            vim.cmd.colorscheme("moonfly")
        end, 
    },
    {
        "mfussenegger/nvim-jdtls",
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "moonfly",
                    component_separators = "",
                    section_separators = {
                        left = "",
                        right = "",
                    },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = {
                        "diagnostics",
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
}
