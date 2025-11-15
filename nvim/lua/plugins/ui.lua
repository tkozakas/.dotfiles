return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-telescope/telescope.nvim" },
	opts = {
		lsp_file_methods = { enabled = false },
		view_options = { show_hidden = true },
		watch_for_changes = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		prompt_save_on_select_new_entry = false,
	},
	config = function(_, opts)
		local funcs = require("core.functions")

		require("oil").setup(opts)
		vim.keymap.set("n", "<leader>e", require("oil").open, { desc = "Open file explorer" })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "oil",
			callback = function(args)
				vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {
					buffer = args.buf,
					desc = "[F]ind [F]iles (from Oil)",
				})
				vim.keymap.set("n", "<leader>sg", require("telescope").extensions.live_grep_args.live_grep_args, {
					buffer = args.buf,
					desc = "[S]earch [G]rep (from Oil)",
				})
				vim.keymap.set("n", "<leader>g", funcs.lazygit, {
					buffer = args.buf,
					desc = "Open Lazygit (from Oil)",
				})
			end,
		})
	end,
}
