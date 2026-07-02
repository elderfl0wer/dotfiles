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
                direction = "float", -- makes the terminal float over your code, like VSCode
                float_opts = {
                    border = "curved",
                },
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- optional file icons
        },
        config = function()
            require("nvim-tree").setup({})
        end,
    },
    {
        "lewis6991/gitsigns.nvim"
    },

})
