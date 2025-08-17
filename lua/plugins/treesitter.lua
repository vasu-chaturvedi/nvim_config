return {
    "nvim-treesitter/nvim-treesitter",

    build = ":TSUpdate",
    config = function () 
        local configs = require("nvim-treesitter.configs")


        configs.setup({
            ensure_installed = {
                "go",
                "bash",
                "sql",
                "lua",
                "vim",
                "json",
                "yaml",
                "markdown",
            },
            auto_install = true,
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },  

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>", -- set to `false` to disable one of the mappings
                    node_incremental = "<Enter>",
                    scope_incremental = false,
                    node_decremental = "<Backspace>",
                },
            },
        })

    end
}
