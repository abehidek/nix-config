-- require'lspconfig'.rust_analyzer.setup{}
-- require'lspconfig'.tailwindcss.setup{}
--require'lspconfig'.flow.setup{}
-- require'lspconfig'.hls.setup{}
-- require'lspconfig'.vuels.setup{}
require("lspconfig").rnix.setup({
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end,
})
require("lspconfig").pyright.setup({})
-- require("lspconfig").tsserver.setup({
--   cmd = { "typescript-language-server", "--stdio" },
-- 	-- on_attach = function(client)
-- 	-- 	client.resolved_capabilities.document_formatting = false
-- 	-- 	client.resolved_capabilities.document_range_formatting = false
-- 	-- end,
-- })
require("lspconfig").svelte.setup({})
require("lspconfig").dartls.setup({
	cmd = { "dart", tostring(os.getenv("DART_SDK")) .. "/bin/snapshots/analysis_server.dart.snapshot", "--lsp" },
	-- cmd = { "dart", "/nix/store/z2yhwh6dq36kp271iprkk0hjr7yx6nyx-dart-2.14.3/bin/snapshots/analysis_server.dart.snapshot", "--lsp" };
})
require("lspconfig").java_language_server.setup({
	cmd = { tostring(os.getenv("JAVALSP")) .. "/share/java/java-language-server/lang_server_linux.sh" },
})

local sumneko_root_path = vim.fn.stdpath("cache") .. "/lspconfig/sumneko_lua/lua-language-server"
local sumneko_binary = "lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
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
