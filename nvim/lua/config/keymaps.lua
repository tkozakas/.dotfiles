local map = vim.keymap.set

map("n", "<leader>tr", ":vsplit | terminal<CR>", {
  desc = "Open terminal on the right",
})

map("n", "<leader>H", "<C-w>H", { desc = "Window → far left" })
map("n", "<leader>J", "<C-w>J", { desc = "Window → bottom" })
map("n", "<leader>K", "<C-w>K", { desc = "Window → top" })
map("n", "<leader>L", "<C-w>L", { desc = "Window → far right" })

map("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows CW" })
map("n", "<leader>wR", "<C-w>R", { desc = "Rotate windows CCW" })
map("n", "<leader>wx", "<C-w>x", { desc = "Swap with next window" })

map("n", "<leader>h", "<C-w>h", { desc = "Focus left window" })
map("n", "<leader>j", "<C-w>j", { desc = "Focus bottom window" })
map("n", "<leader>k", "<C-w>k", { desc = "Focus top window" })
map("n", "<leader>l", "<C-w>l", { desc = "Focus right window" })

map("n", "<leader>uc", [[:g/^\s*\(#\|\/\/\|--\)/d<CR>]], {
  desc = "🗑️ Delete all comment lines",
})
