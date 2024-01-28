return {
    {
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_background = "hard"
            -- vim.cmd.colorscheme('everforest')
        end,
    },
    {
        "AlexvZyl/nordic.nvim",
        config = function()
            require("nordic").setup({
                override = {
                    Visual = {
                        bg = "#3A515D",
                    },
                },
            })

            -- vim.cmd.colorscheme('nordic')
        end,
    },
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_disable_italic_comment = 1
            vim.cmd.colorscheme('gruvbox-material')
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup({
                italic = {
                    folds = false,
                    strings = false,
                    comments = false,
                    emphasis = false,
                    operators = false,
                }
            })
            -- vim.cmd.colorscheme("gruvbox")
        end,
    },
    {
        "projekt0n/github-nvim-theme",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("github-theme").setup({})

            -- vim.cmd.colorscheme('github_dark_dimmed')
            -- vim.cmd.colorscheme('github_dark')
        end,
    },
    {
        "Shatur/neovim-ayu",
        config = function()
            local colors = require("ayu.colors")
            require("ayu").setup({
                dark = true,
                overrides = function()
                    return { Comment = { fg = colors.comment } }
                end,
            })

            -- vim.cmd.colorscheme('ayu')
        end,
    },
}
