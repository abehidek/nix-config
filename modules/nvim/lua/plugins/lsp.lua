-- require'lspconfig'.rust_analyzer.setup{}
-- require'lspconfig'.tailwindcss.setup{}
-- require'lspconfig'.flow.setup{}
-- require'lspconfig'.hls.setup{}
-- require'lspconfig'.vuels.setup{}
local nvim_lsp = require("lspconfig")
local protocol = require("vim.lsp.protocol")

local function lsp_highlight_document(client)
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	lsp_highlight_document(client)
	local opts = { noremap = true, silent = true }

	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.name == "rnix" then
		client.resolved_capabilities.document_formatting = false
	end

	protocol.CompletionItemKind = {
		"", -- Text
		"", -- Method
		"", -- Function
		"", -- Constructor
		"", -- Field
		"", -- Variable
		"", -- Class
		"ﰮ", -- Interface
		"", -- Module
		"", -- Property
		"", -- Unit
		"", -- Value
		"", -- Enum
		"", -- Keyword
		"﬌", -- Snippet
		"", -- Color
		"", -- File
		"", -- Reference
		"", -- Folder
		"", -- EnumMember
		"", -- Constant
		"", -- Struct
		"", -- Event
		"ﬦ", -- Operator
		"", -- TypeParameter
	}
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
nvim_lsp.rnix.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
nvim_lsp.pyright.setup({
	handlers = { ["textDocument/publishDiagnostics"] = function(...) end },
})
nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
nvim_lsp.cssls.setup({
	capabilities = capabilities,
  cmd = { "css-languageserver", "--stdio" }
})
nvim_lsp.html.setup({
  capabilities = capabilities,
  cmd = { "html-languageserver", "--stdio"},
  filetypes = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
})
nvim_lsp.svelte.setup({})
nvim_lsp.dartls.setup({
	cmd = { "dart", tostring(os.getenv("DART_SDK")) .. "/bin/snapshots/analysis_server.dart.snapshot", "--lsp" },
	-- cmd = { "dart", "/nix/store/z2yhwh6dq36kp271iprkk0hjr7yx6nyx-dart-2.14.3/bin/snapshots/analysis_server.dart.snapshot", "--lsp" };
})
nvim_lsp.java_language_server.setup({
	cmd = { tostring(os.getenv("JAVALSP")) .. "/share/java/java-language-server/lang_server_linux.sh" },
})

local sumneko_root_path = vim.fn.stdpath("cache") .. "/lspconfig/sumneko_lua/lua-language-server"
local sumneko_binary = "lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup({
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				preloadFileSize = 120,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
