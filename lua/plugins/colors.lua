return {
    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        config = function()
            vim.o.background = "dark" -- or "light" for light mode

            local cmds = {
                "let g:gruvbox_material_background = 'hard'",
                "let g:gruvbox_material_transparent_background = 2",
                "let g:gruvbox_material_diagnostic_line_highlight = 1",
                "let g:gruvbox_material_diagnostic_virtual_text = 'colored'",
                "let g:gruvbox_material_enable_bold = 1",
                "let g:gruvbox_material_enable_italic = 1",
                "colorscheme gruvbox-material",
            }

            for _, cmd in ipairs(cmds) do
                vim.cmd(cmd)
            end
        end,
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000, -- Make sure to load this before all the other start plugins.
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("tokyonight").setup({
                styles = {
                    comments = { italic = false }, -- Disable italics in comments
                },
            })
            --vim.cmd.colorscheme 'tokyonight-night'
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        branch = "master",

        config = function()
            require("kanagawa").setup({
                transparent = true,
                overrides = function(colors)
                    return {
                        ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
                        ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
                        ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
                        ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
                        ["@markup.list.markdown"] = { link = "Function" }, -- + list
                        ["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
                        ["@markup.list.checked.markdown"] = { link = "WarningMsg" }, -- - [X] checked list item
                    }
                end,
            })
            --vim.cmd("colorscheme kanagawa");
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },
}
