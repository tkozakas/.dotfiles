return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			{
				"zbirenbaum/copilot-cmp",
				event = "LspAttach",
				config = function()
					require("copilot_cmp").setup()
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<Enter>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{ name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
				},
			})
		end,
	},
	{
		"github/copilot.vim",
		config = function()
			vim.keymap.set("i", "<Tab>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})

			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			vim.g.opencode_opts = {
				provider = {
					enabled = "tmux", -- Default when running inside a `tmux` session.
					tmux = {
						options = "-h -p 30", -- options to pass to `tmux split-window`
					},
				},
			}
			vim.o.autoread = true

		end,
	},
}

