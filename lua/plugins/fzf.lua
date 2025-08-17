-- fzf-lua configuration for Neovim

-- This file sets up ibhagwan/fzf-lua as a standalone fuzzy finder

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      -- Optional: icons support
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()

      local fzf = require('fzf-lua')
      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.50,
          preview = { default = 'bat', border = 'border' },
        },
        keymap = {
          builtin = {

            -- Use <C-j>/<C-k> to move selection
            ['<C-j>'] = 'down',
            ['<C-k>'] = 'up',
          },
        },

      })


      -- Keymaps (mirroring your Telescope setup)
      vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = '[S]earch [H]elp (fzf-lua)' })
      vim.keymap.set('n', '<leader>fk', fzf.keymaps, { desc = '[S]earch [K]eymaps (fzf-lua)' })

      vim.keymap.set('n', '<leader>ff', fzf.files, { desc = '[S]earch [F]iles (fzf-lua)' })

      vim.keymap.set('n', '<leader>fs', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
      vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = '[S]earch current [W]ord (fzf-lua)' })
      vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = '[S]earch by [G]rep (fzf-lua)' })
      vim.keymap.set('n', '<leader>fd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics (fzf-lua)' })
      vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = '[S]earch [R]esume (fzf-lua)' })
      vim.keymap.set('n', '<leader>f.', fzf.oldfiles, { desc = '[S]earch Recent Files (fzf-lua)' })
      vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers (fzf-lua)' })
      vim.keymap.set('n', '<leader>/', function()
        fzf.blines() -- preview enabled by default
      end, { desc = '[/] Fuzzily search in current buffer (fzf-lua)' })
      vim.keymap.set('n', '<leader>s/', function()

        fzf.live_grep({ grep_open_files = true, prompt = 'Live Grep in Open Files' })
      end, { desc = '[S]earch [/] in Open Files (fzf-lua)' })
      vim.keymap.set('n', '<leader>sn', function()
        fzf.files({ cwd = vim.fn.stdpath('config') }) -- preview enabled by default
      end, { desc = '[S]earch [N]eovim files (fzf-lua)' })
    end,

  },

}

