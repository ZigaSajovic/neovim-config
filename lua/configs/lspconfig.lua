-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
lspconfig.servers = { "lua_ls", "clangd", "pylsp", "cmake" }
local default_servers = { "pylsp", "cmake" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = (function()
          local lib = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          }

          -- Dynamically add all `lazy.nvim` plugins to the library
          local lazy_path = vim.fn.stdpath "data" .. "/lazy"
          if vim.fn.isdirectory(lazy_path) == 1 then
            local seen = {}
            for _, plugin in ipairs(vim.fn.readdir(lazy_path)) do
              local plugin_path = lazy_path .. "/" .. plugin .. "/lua"
              if vim.fn.isdirectory(plugin_path) == 1 and not seen[plugin_path] then
                table.insert(lib, plugin_path)
                seen[plugin_path] = true
              end
            end
          end

          return lib
        end)(),
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      telemetry = {
        enable = false, -- Disable telemetry
      },
    },
  },
}
