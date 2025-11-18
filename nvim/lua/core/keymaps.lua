-- This file centralizes all keymaps for better organization and discoverability.
-- The philosophy is to use mnemonic prefixes:
--  <leader>f -> file
--  <leader>g -> git
--  <leader>b -> buffer
--  <leader>d -> diagnostics (quickfix)
--  <leader>p -> project (could also be used for plugin-specific actions)

-- Center screen on half-page jumps for better context
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down and Center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up and Center" })

-- === Buffer Management ===
vim.keymap.set("n", "<leader>b", "<C-^>", { desc = "Switch to previous [b]uffer" })

-- === Git ===
-- Grouping git commands under <leader>g
vim.keymap.set("n", "<leader>gg", function()
	require("core.functions").lazygit()
end, { desc = "[G]it [G]UI (lazygit)" })
vim.keymap.set("n", "<leader>gc", ":Gcommit<CR>", { desc = "[G]it [C]ommit" })
vim.keymap.set("n", "<leader>gh", ":Gh<CR>", { desc = "Open on [G]it[H]ub" })
vim.keymap.set(
	"n",
	"<leader>gp",
	require("core.functions").open_or_create_pr,
	{ desc = "[G]it: Open or Create [P]ull Request", silent = true }
)

-- === Diagnostics / Quickfix List ===
-- Grouping diagnostics and quickfix under <leader>d
vim.keymap.set("n", "<leader>do", ":copen<CR>", { desc = "[D]iagnostics [O]pen List" })
vim.keymap.set("n", "<leader>dc", ":cclose<CR>", { desc = "[D]iagnostics [C]lose List" })
vim.keymap.set("n", "<leader>dn", ":cnext<CR>", { desc = "[D]iagnostics [N]ext Item" })
vim.keymap.set("n", "<leader>dp", ":cprevious<CR>", { desc = "[D]iagnostics [P]revious Item" })

--CTRL-W s: Splits the current window horizontally, creating a new window below the current one.[1]
--CTRL-W v: Splits the current window vertically, creating a new window to the right of the current one.[1]

-- Create new tmux splits from Neovim
vim.keymap.set("n", "<leader>th", function()
	require("core.functions").tmux_split_horizontal()
end, { desc = "[T]mux split [H]orizontal" })
vim.keymap.set("n", "<leader>tv", function()
	require("core.functions").tmux_split_vertical()
end, { desc = "[T]mux split [V]ertical" })

-- Delete without yanking to avoid overwriting the clipboard
vim.keymap.set("n", "d", '"_d', { desc = "Delete (no yank)" })
vim.keymap.set("x", "d", '"_d', { desc = "Delete selection (no yank)" })

vim.keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
end)

-- Move selected lines up and down in visual mode
vim.keymap.set("v", "<C-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-Up>", ":m '<-2<CR>gv=gv")

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = false, noremap = true })
vim.keymap.set({ "n", "t" }, "<leader>q", ":q<cr>", { silent = false, noremap = true })

-- Little one from Primeagen to mass replace string in a file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false })

-- Disable arrow keys to encourage use of hjkl for navigation
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")


