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
        "bluz71/vim-moonfly-colors",
    },

    {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        direction = "float",
        float_opts = {
            border = "rounded", -- "single", "double", "shadow", etc.
            width = 120,
            height = 30,
        },
        shell = "pwsh",
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
    },
}

