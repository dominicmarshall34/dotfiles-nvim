return {
	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 35,
					relativenumber = true,
				},
				renderer = {
					indent_markers = {
						enable = true,
					},
				},
				actions = {
					open_file = {
						window_picker = {
							enable = false,
						},
					},
				},
				filters = {
					custom = { ".DS_Store" },
				},
				git = {
					ignore = false,
				},
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
			vim.keymap.set(
				"n",
				"<leader>ef",
				"<cmd>NvimTreeFindFileToggle<CR>",
				{ desc = "Toggle file explorer on current file" }
			)
			vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
			vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "truncate" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
			})

			telescope.load_extension("fzf")

			-- Keymaps
			local keymap = vim.keymap
			keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
			keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
			keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
			keymap.set(
				"n",
				"<leader>fc",
				"<cmd>Telescope grep_string<cr>",
				{ desc = "Find string under cursor in cwd" }
			)
			keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
			keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help" })
		end,
	},

	-- Which-key (v3 spec)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- Optional: modern hints & a small delay feel nice
			preset = "modern",
			delay = 300,
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)

			-- <leader> groups (no remaps created; just labels/groups)
			wk.add({
				-- Clipboard / yank
				{ "<leader>y", group = "Clipboard" },
				{ "<leader>yy", desc = "Yank to clipboard", mode = "n" },
				{ "<leader>yl", desc = "Yank line to clipboard", mode = "n" },
				{ "<leader>ya", desc = "Yank all to clipboard", mode = "n" },

				-- Explorer (nvim-tree)
				{ "<leader>e", group = "Explorer" },
				{ "<leader>ee", desc = "Toggle file explorer", mode = "n" },
				{ "<leader>ef", desc = "Toggle on current file", mode = "n" },
				{ "<leader>ec", desc = "Collapse file explorer", mode = "n" },
				{ "<leader>er", desc = "Refresh file explorer", mode = "n" },

				-- Telescope finders
				{ "<leader>f", group = "Find (Telescope)" },
				{ "<leader>ff", desc = "Find files", mode = "n" },
				{ "<leader>fr", desc = "Recent files", mode = "n" },
				{ "<leader>fs", desc = "Live grep", mode = "n" },
				{ "<leader>fc", desc = "Grep word under cursor", mode = "n" },
				{ "<leader>fb", desc = "Buffers", mode = "n" },
				{ "<leader>fh", desc = "Help tags", mode = "n" },

				-- Git (gitsigns)
				{ "<leader>h", group = "Git (hunks)" },
				{ "<leader>hs", desc = "Stage hunk", mode = { "n", "v" } },
				{ "<leader>hr", desc = "Reset hunk", mode = { "n", "v" } },
				{ "<leader>hS", desc = "Stage buffer", mode = "n" },
				{ "<leader>hR", desc = "Reset buffer", mode = "n" },
				{ "<leader>hu", desc = "Undo stage hunk", mode = "n" },
				{ "<leader>hp", desc = "Preview hunk", mode = "n" },
				{ "<leader>hb", desc = "Blame line (full)", mode = "n" },
				{ "<leader>hB", desc = "Toggle line blame", mode = "n" },
				{ "<leader>hd", desc = "Diff this", mode = "n" },
				{ "<leader>hD", desc = "Diff this ~", mode = "n" },

				-- Format (conform)
				{ "<leader>m", group = "Format" },
				{ "<leader>mp", desc = "Format file/range", mode = { "n", "v" } },

				-- Code / LSP actions
				{ "<leader>c", group = "Code" },
				{ "<leader>ca", desc = "Code action", mode = { "n", "v" } },

				{ "<leader>r", group = "LSP" },
				{ "<leader>rn", desc = "Rename LSP style...", mode = "n" },
				{ "<leader>rs", desc = "Restart LSP", mode = "n" },

				{ "<leader>d", group = "Diagnostics" },
				{ "<leader>dl", desc = "Line diagnostics (float)", mode = "n" },
				{ "<leader>dd", desc = "Buffer diagnostics (Telescope)", mode = "n" },

				-- Harpoon (under <leader>p)
				{ "<leader>p", group = "Harpoon" },
				{ "<leader>pp", desc = "Telescope menu", mode = "n" },
				{ "<leader>pa", desc = "Add file", mode = "n" },
				{ "<leader>pr", desc = "Remove file", mode = "n" },
				{ "<leader>p1", desc = "File 1", mode = "n" },
				{ "<leader>p2", desc = "File 2", mode = "n" },
				{ "<leader>p3", desc = "File 3", mode = "n" },
				{ "<leader>p4", desc = "File 4", mode = "n" },

				-- Optional cycling if you enable those mappings:
				{ "<leader>pn", desc = "Next", mode = "n" },
				{ "<leader>pp", desc = "Prev", mode = "n" },
			})

			-- LSP navigation under plain `g` (again: labels only)
			wk.add({
				{ "g", group = "Goto (LSP)" },
				{ "gd", desc = "Definitions", mode = "n" },
				{ "gD", desc = "Declaration", mode = "n" },
				{ "gi", desc = "Implementations", mode = "n" },
				{ "gt", desc = "Type definitions", mode = "n" },
				{ "gR", desc = "References", mode = "n" },
			})

			-- Other non-leader keys you want labeled
			wk.add({
				{ "[d", desc = "Prev diagnostic", mode = "n" },
				{ "]d", desc = "Next diagnostic", mode = "n" },
				{ "K", desc = "Hover documentation", mode = "n" },
			})
		end,
	},
	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				map("n", "]h", gs.next_hunk, "Next Hunk")
				map("n", "[h", gs.prev_hunk, "Prev Hunk")

				-- Actions
				map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
				map("n", "<leader>hd", gs.diffthis, "Diff this")
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, "Diff this ~")
			end,
		},
	},
	-- Harpoon 2 (quick file jump list + Telescope UI)
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({})

			-- Minimal Telescope UI for Harpoon (your approach)
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_list)
				local file_paths = {}
				for _, item in ipairs(harpoon_list.items) do
					table.insert(file_paths, item.value)
				end
				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({ results = file_paths }),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			-- Keymaps under <leader>p
			vim.keymap.set("n", "<leader>pp", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Harpoon: Telescope menu" })

			vim.keymap.set("n", "<leader>pa", function()
				harpoon:list():add()
			end, { desc = "Harpoon: Add file" })

			vim.keymap.set("n", "<leader>pr", function()
				harpoon:list():remove()
			end, { desc = "Harpoon: Remove file" })

			-- Quick select slots
			vim.keymap.set("n", "<leader>p1", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon: File 1" })
			vim.keymap.set("n", "<leader>p2", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon: File 2" })
			vim.keymap.set("n", "<leader>p3", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon: File 3" })
			vim.keymap.set("n", "<leader>p4", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon: File 4" })

			-- Optional cycling
			vim.keymap.set("n", "<leader>pn", function()
				harpoon:list():next()
			end, { desc = "Harpoon: Next" })
			vim.keymap.set("n", "<leader>pp", function()
				harpoon:list():prev()
			end, { desc = "Harpoon: Prev" })
		end,
	},
}
