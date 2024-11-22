local cmp = require "cmp"
local nvc = require "nvchad.configs.cmp"

nvc.sources = {
  { name = "nvim_lsp" },
  { name = "luasnip" },
  { name = "buffer" },
  { name = "nvim_lua" },
  { name = "path", option = { trailing_slash = true, label_trailing_slash = true } },
}

nvc.completion.completeopt = "menu,menuone,noselect"
local is_prompt = function()
  local buftype = vim.bo.buftype
  if buftype == "prompt" then
    return true
  end
  return false
end

nvc.enabled = function()
  if is_prompt() then
    return false
  else
    return true
  end
end

nvc.mapping = {
  ["<C-p>"] = cmp.mapping.select_prev_item(),
  ["<C-n>"] = cmp.mapping.select_next_item(),
  ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping(
    cmp.mapping.complete {
      reason = cmp.ContextReason.Auto,
    },
    { "i", "c" }
  ),
  ["<C-e>"] = cmp.mapping.close(),
  ["<C-y>"] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Insert,
    select = true,
  },
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif require("luasnip").expand_or_jumpable() then
      require("luasnip").expand_or_jump()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif require("luasnip").jumpable(-1) then
      require("luasnip").jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
}
local compare = require "cmp.config.compare"
nvc.matching = {
  disallow_fuzzy_matching = false, -- Enable fuzzy matching
  disallow_fullfuzzy_matching = true, -- Disable out-of-order full fuzzy matching
  disallow_partial_fuzzy_matching = false, -- Allow partial fuzzy matching
  disallow_partial_matching = false, -- Allow partial matches
  disallow_prefix_unmatching = true, -- Only allow prefix matches
}

nvc.sorting = {
  priority_weight = 1.5,
  comparators = {
    compare.exact,
    compare.scopes,
    compare.locality,
    compare.offset,
    compare.sort_text,
    compare.score,
    compare.recently_used,
    compare.kind,
    compare.length,
    compare.order,
  },
}

cmp.setup(nvc)

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    {
      name = "cmdline",
      option = {
        ignore_cmds = { "Man", "!" },
      },
    },
    { name = "path", option = { trailing_slash = true, label_trailing_slash = true } },
    { name = "buffer" },
  },
})
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})
