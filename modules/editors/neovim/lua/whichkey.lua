local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end
local mappings = {
	q = { ":q<cr>", "Quit" },
	f = { "<cmd>Telescope find_files<CR>", "Find file" },
	w = { "<cmd>Telescope live_grep<CR>", "Grep files" },
	e = { ":execute 'NvimTreeRefresh' | NvimTreeToggle<CR>", "Tree" },
	t = { ":! kitty --detach <CR>", "Kitty" },
	h = { "<cmd>nohlsearch<CR>", "No Highlight" },
	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		g = {
			"<cmd>Telescope lsp_document_diagnostics<cr>",
			"Document Diagnostics",
		},
		d = {
			"<cmd>lua vim.lsp.buf.definition()<CR>",
			"Definition",
		},
		D = {
			"<cmd>lua vim.lsp.buf.declaration()<CR>",
			"Declarations",
		},
		w = {
			"<cmd>Telescope lsp_workspace_diagnostics<cr>",
			"Workspace Diagnostics",
		},
		f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		j = {
			"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
		R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
		t = {
			"<cmd>lua vim.lsp.buf.type_definition()<CR>",
			"Type definition",
		},
	},
	g = {
		name = "Git",
		d = { ":Gvdiffsplit<CR>", "Diff" },
		l = { ":! kitty --detach lazygit <CR>", "Lazygit in kitty" },
		-- j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		-- k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		-- L = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		-- p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		-- r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		-- R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		-- s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		-- u = {
		-- 	"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
		-- 	"Undo Stage Hunk",
		-- },
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
	},
}

local opts = { prefix = "<leader>" }
which_key.register(mappings, opts)
