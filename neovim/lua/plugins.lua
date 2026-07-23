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
    
    -- {
    --     "bluz71/vim-moonfly-colors",
    -- },

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
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_background = "medium"
        vim.g.gruvbox_material_foreground = "material"
        vim.g.gruvbox_material_enable_italic = true

        vim.cmd.colorscheme("gruvbox-material")
    end,
},

{
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        require("lualine").setup({
            options = {
                theme = "gruvbox-material",
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

