return {
  'tpope/vim-sleuth',

  { 'windwp/nvim-autopairs', config = true },

  {
    'Wansmer/treesj',
    lazy = false,
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        max_join_length = 80,
      })
    end,
    keys = {
      {
        '<leader>/',
        function()
          require('treesj').toggle()
        end,
      },
    },
  },

  {
    'pocco81/auto-save.nvim',
    opts = {
      enabled = true,
      trigger_events = { 'InsertLeave' },
      execution_message = { message = '' },
      condition = function(buf)
        if vim.bo[buf].filetype == 'harpoon' then
          return false
        end
        return true
      end,
    },
  },
}
