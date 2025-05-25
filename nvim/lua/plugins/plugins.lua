return {

  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter", -- load on first insert
    opts = {
      panel = { enabled = false }, -- disable Copilot’s separate panel
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-l>", -- <Ctrl-l> to accept suggestion
          next = "<C-;>", -- <Ctrl-;> to cycle next
          prev = "<C-,>", -- <Ctrl-,> to cycle prev
          dismiss = "<Esc>", -- <Esc> to dismiss
        },
      },
      filetypes = {
        yaml = false, -- example: disable for yaml
      },
    },
  },

  require("neo-tree").setup({
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  }),
}
